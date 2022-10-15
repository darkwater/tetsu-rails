class Anidb::GetFileInfoJob < ApplicationJob
  queue_as :default

  def perform(file)
    file.anime_or_fetch
    file.episode_or_fetch
    file.group_or_fetch
  end
end
