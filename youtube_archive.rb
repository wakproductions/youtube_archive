require 'pry-byebug'

DOWNLOAD_FOLDER='/Users/wkotzan/Movies/YouTube'

FILENAME_FORMAT="%(uploader)s-%(upload_date)s-%(playlist_index)s-%(title)s-%(id)s.%(ext)s"

module Downloader
  def download_playlist(playlist_name, url, start_index)
    `#{build_command(playlist_name, url, start_index)}`
  end

  private

  def build_command(playlist_name, url, start_index)
    # http://stackoverflow.com/questions/10224481/running-a-command-from-ruby-displaying-and-capturing-the-output
    system(
      "youtube-dl -i -f mp4 --playlist-start #{start_index} -o '#{dest_dir(playlist_name)}/#{FILENAME_FORMAT}' #{url}",
      out: $stdout,
      err: :out
    )

  end

  def dest_dir(playlist_name)
    File.join(DOWNLOAD_FOLDER, playlist_name)
  end
end


class YoutubeArchive
  include Downloader

  def download!
    list = load_list

    list.each do |playlist_details|
      download_playlist(*playlist_details)
    end

    # update_list
  end

  def load_list
    File.open(
      File.join(Dir.pwd, 'playlists.txt'),
      'r'
    ) do |f|
      list = f.read.split("\n").map { |l| l.split(',') }
      list.shift  # pop the header row
      list
    end
  end
end



YoutubeArchive.new.download!