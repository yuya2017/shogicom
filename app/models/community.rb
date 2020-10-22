class Community < ApplicationRecord

  belongs_to :user
  has_many :community_users, dependent: :destroy
  has_one :room, dependent: :destroy
  accepts_nested_attributes_for :room

  validates :community_place, presence: true
  validates :community_date, presence: true
  validates :community_limit, presence: true
  validates :community_money, presence: true

  validates :user_id, presence: true

  def self.community_user_create(user_id, community_id)
    user = CommunityUser.new(
      user_id: user_id,
      community_id: community_id
    )
    user.save
  end


  def self.enterCommunity(user_id, community_id)
    room = Room.find_by(community_id: community_id)
    user_key = []
    users = CommunityUser.where(community_id: community_id)
    users.each do |user|
      user_key.push(user.user_id)
    end
    if user_key.include?(user_id)
      return room
    else
      community_key = CommunityUser.new(
        user_id: user_id,
        community_id: community_id
      )
      community_key.save
      return room
    end
  end
end
