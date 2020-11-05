class Message < ApplicationRecord

  belongs_to :user
  belongs_to :room

  validates :message_content, presence: true, length: { maximum: 100 }

  def self.message_error(message)
    room = Room.find(message.room_id)
    if room.private_id.present?
      "private"
    elsif room.post_id.present?
      "post"
    elsif room.tournament_id.present?
      "tournament"
    else room.community_id.present?
      "community"
    end
  end
end
