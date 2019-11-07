class UpdateAttachmentRecords < ActiveRecord::Migration[5.2]
  def change
    ActiveStorage::Attachment.where(record_type: "CarouselImage").
      update_all(record_type: "PieceImage")
  end
end
