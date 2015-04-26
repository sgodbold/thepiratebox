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

  # Returns all info
  def info_get
    data = @transmission_api.all
    render :json => data
  end

  # Only info when something has changed returns 0 if nothing has changed.
  # Use this method to frequently ping for new info.
  def info_update
    # Get info from transmission and strip useless data
    data = @transmission_api.all
    data.each do |torrent|
      torrent.delete('files')
    end

    # Create copy for hashing
    data_sig = data.clone

    # Get client ip and current torrent signiture
    client_ip = request.remote_ip.to_s
    sig = createsig(data_sig)
    puts "Sig: #{sig}"

    # Create new key for first time request
    if !Rails.cache.exist?(client_ip)
      puts "No key!"
      Rails.cache.write(client_ip, {"torrent_sig" => 0})
    else
      puts "Has key with value #{Rails.cache.fetch(client_ip)}"
    end

    client_cache = Rails.cache.fetch(client_ip)

    # Check if data has changed since last request
    if client_cache["torrent_sig"] == sig
      render :json => 0
    else
      # Update cache value and send new json
      client_cache["torrent_sig"] = sig
      Rails.cache.write(client_ip, client_cache)

      puts "sending: #{JSON.pretty_generate(data)}"

      render :json => data
    end
  end
end
