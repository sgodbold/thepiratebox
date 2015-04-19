class WelcomeController < ApplicationController
  def index
    @torrents = Torrent.all
    @magnets = Magnet.all
    @new_torrent = Torrent.new
    @new_magnet = Magnet.new

    # Disk space used
    disk = %x[df -h | sed -n '2p']
    disk = disk.split(' ')
    @disk_used = disk[2]
    @disk_total = disk[1]
    @disk_percent = disk[4]

    # All torrent data
    @torrent_data = @transmission_api.all
    # @transmission_api.destroy(5)
    puts JSON.pretty_generate(@torrent_data)
  end
end
