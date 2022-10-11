require "socket"
require "timeout"

CLIENT_NAME = "tetsu"
FMASK = "71c2fef800"

module Anidb
  class Anidb
    include Singleton

    def initialize
      @sock = UDPSocket.new
      @sock.bind("0.0.0.0", 12345)

      auth
    end

    def send(data)
      # limit to one request every 2 seconds as per API restrictions
      while not Redis.new.set("anidb:rate_limit", "", ex: 2, nx: true)
        sleep 0.2
      end

      puts "sending: #{data}"
      @sock.send(data, 0, "api.anidb.net", 9000)
    end

    def request(cmd, args)
      args[:s] = @key unless %w(PING ENCRYPT ENCODING AUTH VERSION).include?(cmd)

      pairs = args.map do |k, v|
        esc = v.gsub(/&/, "&amp;").gsub(/\n/, "<br />") if v.is_a?(String)
        esc = 1 if v.is_a?(TrueClass)
        esc = 0 if v.is_a?(FalseClass)
        esc = v.to_s if esc.nil?
        "#{k}=#{esc}"
      end

      req = "#{cmd} #{pairs.join("&")}\n"

      send(req)

      Timeout::timeout(5) do
        resp, addr = @sock.recvfrom(1400)

        resp
      end
    end

    def auth
      user = Rails.application.credentials.anidb.user
      pass = Rails.application.credentials.anidb.pass

      res = request("AUTH", user: user, pass: pass, protover: 3, client: CLIENT_NAME, clientver: 1, enc: "UTF8")

      if key = res[/^(?:200|201) ([^ ]+) /, 1]
        @key = key
      else
        raise "Authentication failed: #{res}"
      end
    end

    def file_by_ed2k(size:, hash:)
      res = request("FILE", size: size, ed2k: hash, fmask: FMASK, amask: "00000000")

      if res =~ /^220 FILE/
        data = res.split("\n")[1].split("|")
        fields = %i(id anime_id episode_id group_id state size ed2k
                    colour_depth quality source audio_codec_list
                    audio_bitrate_list video_codec video_bitrate
                    video_resolution dub_language sub_language
                    length_in_seconds description aired_date)

        File.new(fields.zip(data).to_h)
      else
        raise "File not found: #{res}"
      end
    end
  end
end
