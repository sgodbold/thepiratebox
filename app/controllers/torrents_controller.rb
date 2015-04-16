class TorrentsController < ApplicationController
  def new
    @torrent = Torrent.new
  end

  def create
    @torrent = Torrent.new(torrent_params)
    @torrent.filename = File.basename(@torrent.attachment.to_s)
    if @torrent.save
      redirect_to root_path, notice: "Torrent successfully uploaded."
    else
      redirect_to root_path, notice: "ERROR! torrent upload is missing data."
    end
  end

  def destroy
    @torrent = Torrent.find(params[:id])
    @torrent.destroy

    redirect_to root_path, notice: "Torrent successfully destroyed."
  end

  private
    def torrent_params
      params.require(:torrent).permit(:filename, :attachment)
    end
end
