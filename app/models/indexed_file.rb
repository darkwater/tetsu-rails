class IndexedFile < ApplicationRecord
  belongs_to :file, optional: true, polymorphic: true

  def self.index(path)
    idxfile = IndexedFile.find_or_initialize_by(path: path)

    ed2k = Digest::ED2K.file(path).hexdigest
    size = File.size(path)

    file = Anidb::File.find_or_fetch_by_ed2k(size: size, ed2k: ed2k) rescue nil
    Anidb::GetFileInfoJob.perform_later(file) if file

    idxfile.update(
      filename: File.basename(path),
      ed2k: ed2k,
      filesize: size,
      file: file,
    )
  end
end
