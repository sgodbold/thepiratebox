class MagnetsController < ApplicationController
  def new
    @magnet = Magnet.new
  end

  def create
    @magnet = Magnet.new(magnet_params)
    if (@magnet.url =~ /magnet:\?xt=urn:.*/ )
      puts "valid magnet"
      keys = Rack::Utils.parse_nested_query(@magnet.url)
      puts "keys = #{keys}"
      puts "dn = #{keys["dn"]}"
      @magnet.download_name = Rack::Utils.parse_nested_query(@magnet.url)["dn"]

      if @magnet.save
        redirect_to root_path, notice: "Magnet successfully uploaded."
      else
        redirect_to root_path, notice: "ERROR! cannot upload magnet."
      end

    else
      redirect_to root_path, error: "ERROR! invalid magnet URL."
    end
  end

  def destroy
    @magnet = Magnet.find(params[:id])
    @magnet.destroy

    redirect_to root_path, notice: "Magnet successfully destroyed."
  end

  private
    def magnet_params
      params.require(:magnet).permit(:url, :download_name)
    end
end
