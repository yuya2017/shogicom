class Post < ApplicationRecord

  belongs_to :user
  has_one :room, dependent: :destroy
  accepts_nested_attributes_for :room

  validates :post_chess, presence: true, length: { maximum: 10 }
  validates :post_app, presence: true, length: { maximum: 20 }
  validates :post_time, presence: true, length: { maximum: 15 }
  validates :user_id, presence: true
  validates :post_all_tag, length: { maximum: 50 }
  validates :post_content, length: { maximum: 100 }

end
