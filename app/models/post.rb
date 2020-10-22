class Post < ApplicationRecord

  belongs_to :user
  has_one :room, dependent: :destroy
  accepts_nested_attributes_for :room

  validates :post_chess, presence: true
  validates :post_app, presence: true
  validates :post_time, presence: true
  validates :user_id, presence: true

end
