require "socket"
require "timeout"

CLIENT_NAME = "tetsu"

FMASK = "71c2fef800"
FILE_FIELDS = %i(id anime_id episode_id group_id state size ed2k colour_depth
                 quality source audio_codec_list audio_bitrate_list video_codec
                 video_bitrate video_resolution dub_language sub_language
                 length_in_seconds description aired_date)

AMASK = "fce8ba010080f8"
ANIME_FIELDS = %i(id dateflags year atype related_aid_list related_aid_type
                  romaji_name kanji_name english_name short_name_list episode_count
                  special_ep_count air_date end_date picname nsfw
                  character_id_list specials_count credits_count other_count
                  trailer_count parody_count)

EPISODE_FIELDS = %i(id anime_id length rating votes epno english_name romaji_name
                    kanji_name aired etype)


GROUP_FIELDS = %i(id rating votes acount fcount name short irc_channel irc_server
                  url picname founded_date disbanded_date date_flags
                  last_release_date last_activity_date group_relations)

module Anidb
  class Anidb
    include Singleton

    def initialize
      @redis = Redis.new
    end

    def send(data)
      # limit to one request every 2 seconds as per API restrictions
      while not @redis.set("anidb:rate_limit", "", ex: 2, nx: true)
        sleep 0.5
      end

      puts "sending: #{data}"
      @sock = UDPSocket.new
      @sock.bind("0.0.0.0", 12346)
      @sock.send(data, 0, "api.anidb.net", 9000)
    end

    def request(cmd, args)
      args[:s] = key unless %w(PING ENCRYPT ENCODING AUTH VERSION).include?(cmd)

      pairs = args.map do |k, v|
        esc = v.gsub(/&/, "&amp;").gsub(/\n/, "<br />") if v.is_a?(String)
        esc = 1 if v.is_a?(TrueClass)
        esc = 0 if v.is_a?(FalseClass)
        esc = v.to_s if esc.nil?
        "#{k}=#{esc}"
      end

      req = "#{cmd} #{pairs.join("&")}\n"

      send(req)

      Timeout::timeout(2) do
        res, addr = @sock.recvfrom(1400)
        @sock.close

        res = res.force_encoding("UTF-8")
        puts "received: #{res}"

        if res =~ /^501 LOGIN FIRST/
          @redis.del("anidb:session_key")
          return request(cmd, args)
        end

        res
      end
    end

    def key
      if key = @redis.get("anidb:session_key")
        key
      else
        auth
      end
    end

    def auth
      user = Rails.application.credentials.anidb.user
      pass = Rails.application.credentials.anidb.pass

      res = request("AUTH", user: user, pass: pass, protover: 3, client: CLIENT_NAME, clientver: 1, enc: "UTF8")

      if key = res[/^(?:200|201) ([^ ]+) /, 1]
        @redis.set("anidb:session_key", key, ex: 60 * 35)
        key
      else
        raise "Authentication failed: #{res}"
      end
    end

    def file_by(args)
      res = request("FILE", fmask: FMASK, amask: "00000000", **args)

      if res =~ /^220 FILE/
        data = FILE_FIELDS.zip(res.split("\n")[1].split("|")).to_h
        data[:aired_date] = Time.at(data[:aired_date].to_i) unless data[:aired_date].empty?
        File.new(data)
      else
        raise "File not found: #{res}"
      end
    end

    def file_by_ed2k(size:, ed2k:) = file_by(size: size, ed2k: ed2k)
    def file(fid:) = file_by(fid: fid)

    def anime(aid:)
      res = request("ANIME", amask: AMASK, aid: aid)

      if res =~ /^230 ANIME/
        data = ANIME_FIELDS.zip(res.split("\n")[1].split("|")).to_h
        data[:air_date] = Time.at(data[:air_date].to_i) unless data[:air_date].empty?
        data[:end_date] = Time.at(data[:end_date].to_i) unless data[:end_date].empty?

        related_aids = data.delete(:related_aid_list).split("'")
        related_atypes = data.delete(:related_aid_type).split("'")
        related_anime_pairs = related_aids.zip(related_atypes)

        character_ids = data.delete(:character_id_list).split(",")

        pp data

        a = Anime.find_or_initialize_by(id: data[:id])
        a.assign_attributes(data)

        related_anime_pairs.each do |aid, rtype|
          a.related_anime.build(
            from_id: data[:id],
            to_id: aid,
            rtype: {
              1 => :sequel,
              2 => :prequel,
              11 => :same_setting,
              12 => :alternative_setting,
              32 => :alternative_version,
              41 => :music_video,
              42 => :character,
              51 => :side_story,
              52 => :parent_story,
              61 => :summary,
              62 => :full_story,
              100 => :other,
            }[rtype.to_i] || :unknown,
          )
        end

        character_ids.each do |cid|
          a.related_characters.build(
            anime_id: data[:id],
            character_id: cid,
          )
        end

        a
      else
        raise "Anime not found: #{res}"
      end
    end

    def episode(args)
      res = request("EPISODE", args)

      if res =~ /^240 EPISODE/
        data = EPISODE_FIELDS.zip(res.split("\n")[1].split("|")).to_h
        data[:aired] = Time.at(data[:aired].to_i) unless data[:aired].empty?

        episode = Episode.find_or_initialize_by(id: data[:id])
        episode.assign_attributes(data)
        episode
      else
        raise "Episode not found: #{res}"
      end
    end

    def group(gid:)
      res = request("GROUP", gid: gid)

      if res =~ /^250 GROUP/
        data = GROUP_FIELDS.zip(res.split("\n")[1].split("|")).to_h
        data[:founded_date] = Time.at(data[:founded_date].to_i) unless data[:founded_date].empty?
        data[:disbanded_date] = Time.at(data[:disbanded_date].to_i) unless data[:disbanded_date].empty?
        data[:last_release_date] = Time.at(data[:last_release_date].to_i) unless data[:last_release_date].empty?
        data[:last_activity_date] = Time.at(data[:last_activity_date].to_i) unless data[:last_activity_date].empty?

        group = Group.find_or_initialize_by(id: data[:id])
        group.assign_attributes(data)
        group
      else
        raise "Group not found: #{res}"
      end
    end
  end
end
