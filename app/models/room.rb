class Room < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :post, optional: true
  belongs_to :tournament, optional: true
  belongs_to :community, optional: true
  has_many :messages, dependent: :destroy


  validates :room_name, presence: true

  def self.enterRoom(user_id, private_id)
    if Room.where(user_id: user_id).where(private_id: private_id).present?
      room_key = Room.where(user_id: user_id).where(private_id: private_id)[0].id
    else
      if Room.where(private_id: user_id).where(user_id: private_id).present?
        room_key = Room.where(private_id: user_id).where(user_id: private_id)[0].id
      else
        room_key = Room.new(
          room_name: "個人用チャットルーム",
          user_id: user_id,
          private_id: private_id
        )
      end
    end
  end

end
