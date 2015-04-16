class Torrent < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :filename, presence: true
end
