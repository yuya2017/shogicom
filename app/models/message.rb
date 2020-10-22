class Message < ApplicationRecord

  belongs_to :user
  belongs_to :room

  validates :message_content, presence: true, length: { maximum: 100 }

end
