class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Transmission interface
  before_filter :set_globals
  def set_globals
    @transmission_api = TransmissionApi::Client.new(:url => "http://127.0.0.1:9091/transmission/rpc")
  end

  # Transmission helpers #
  def time2torrent(time_str)
    # Format input time
    time_str = time_str.to_s.gsub(" UTC", "")

    @transmission_api.all.each do |torrent|
      time = Time.at(torrent['addedDate'])
      time = time.to_s.gsub(" +0000", "")

      if time = time_str
        return torrent['id']
      end

    end
    return -1
  end

  # Create a hash signiture of any object. Note: This does not preserve the original object.
  def createsig(body)
    Digest::MD5.hexdigest( sigflat body )
  end

  def sigflat(body)
    if body.class == Hash
      arr = []
      body.each do |key, value|
        arr << "#{sigflat key}=>#{sigflat value}"
      end
      body = arr
    end
    if body.class == Array
      str = ''
      body.map! do |value|
        sigflat value
      end.sort!.each do |value|
        str << value
      end
    end
    if body.class != String
      body = body.to_s << body.class.to_s
    end
    body
  end

  # Cleanup filenames in a standard way. Make changes to uploader too!
  def sanitize_filename(str)
    # Remove surrounding brackets
    sanitize = str.gsub("[", "")
    sanitize = sanitize.gsub("]", "")
    sanitize = sanitize.gsub("(", "")
    sanitize = sanitize.gsub(")", "")
    sanitize = sanitize.gsub("<", "")
    sanitize = sanitize.gsub(">", "")

    # Replace spaces
    sanitize = sanitize.gsub("_", ".")
    sanitize = sanitize.gsub("-", ".")

    # Remove duplicates
    sanitize = sanitize.squeeze(".")

    # Remove starting / trailing spaces
    sanitize = sanitize.gsub(/^\./, "")
    sanitize = sanitize.gsub(/\.$/, "")

    return sanitize
  end
end
