class IndexJob < ApplicationJob
  queue_as :default

  def perform()
    Dir["media/**/*.mkv"].each do |path|
      IndexedFile.index(path)
    end
  end
end
