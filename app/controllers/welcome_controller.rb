class WelcomeController < ApplicationController
  def index
    @torrents = Torrent.all
    @magnets = Magnet.all
    @new_torrent = Torrent.new
    @new_magnet = Magnet.new

    # Get percent of disk space used
    disk = %x[df -h | sed -n '2p']
    disk = disk.split(' ')
    puts "disk = #{disk}"
    @disk_used = disk[2]
    @disk_total = disk[1]
    @disk_percent = disk[4]
  end
end
