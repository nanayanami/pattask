if Gem.win_platform?
  # Use an app-owned temp dir to avoid AV/Defender locks on system temp.
  require "fileutils"
  tmpdir = Rails.root.join("tmp", "image_processing")
  FileUtils.mkdir_p(tmpdir)
  ENV["TMPDIR"] = tmpdir.to_s
  ENV["TEMP"] = tmpdir.to_s
  ENV["TMP"] = tmpdir.to_s

  # On Windows, an open Tempfile can be locked and unreadable by ImageMagick.
  # Close the Tempfile before yielding so the external `magick` process can read it.
  module ActiveStorageWindowsFileLock
    def open(*args, **options)
      super(*args, **options) do |file|
        file.flush
        file.close
        File.open(file.path, "rb") do |reopened|
          yield reopened
        end
      ensure
        file.close if file && !file.closed?
      end
    end
  end

  ActiveStorage::Downloader.prepend(ActiveStorageWindowsFileLock)
end
