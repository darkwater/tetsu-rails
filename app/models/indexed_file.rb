class IndexedFile < ApplicationRecord
  belongs_to :file, optional: true, polymorphic: true

  def self.index(path)
    ed2k = Digest::ED2K.file(path).hexdigest
    size = File.size(path)

    if file = Anidb::File.find_by(ed2k: ed2k, size: size)
      IndexedFile.create(
        path: path,
        filename: File.basename(path),
        ed2k: ed2k,
        filesize: size,
        file: file.file,
      )
    elsif file = Anidb::File.fetch_by_ed2k(size: size, hash: ed2k)
      file.save!
      IndexedFile.create(
        path: path,
        filename: File.basename(path),
        ed2k: ed2k,
        filesize: size,
        file: file,
      )
    else
      IndexedFile.create(
        path: path,
        filename: File.basename(path),
        ed2k: ed2k,
        filesize: size,
      )
    end
  end
end
