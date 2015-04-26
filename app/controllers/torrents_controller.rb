class TorrentsController < ApplicationController
  def new
    @torrent = Torrent.new
  end

  def create
    @torrent = Torrent.new(torrent_params)

    # Get and filename
    str = File.basename(@torrent.attachment.to_s, ".torrent")
    sanitize = sanitize_filename(str)
    @torrent.filename = sanitize

    if @torrent.save
      redirect_to root_path
    else
      redirect_to root_path, notice: "ERROR! torrent upload is missing data."
    end
  end

  def destroy
    @torrent = Torrent.find(params[:id])

    # Find matching transmission torrent
    id = time2torrent(@torrent.created_at)
    if id < 0
      redirect_to root_path, notice: "ERROR! can't find torrent"
    end

    # Remove resource and torrent
    @torrent.destroy
    @transmission_api.destroy(id)

    redirect_to root_path
  end

  private
    def torrent_params
      params.require(:torrent).permit(:filename, :attachment)
    end
end
