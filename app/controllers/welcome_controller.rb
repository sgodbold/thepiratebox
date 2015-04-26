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
  end

  def info_update
    data = @transmission_api.all
    data.each do |torrent|
      puts torrent['id']
      torrent.delete('files')
    end
    puts "sending: #{JSON.pretty_generate(data)}"
    render :json => data
  end
end
