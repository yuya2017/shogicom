class Community < ApplicationRecord

  belongs_to :user
  has_many :community_users, dependent: :destroy
  has_one :room, dependent: :destroy
  accepts_nested_attributes_for :room

  before_validation :geocode
  validates :community_place, presence: true
  validates :community_date, presence: true
  validates :community_limit, presence: true
  validates :community_money, presence: true
  validates :user_id, presence: true
  validates :community_all_tag, length: { maximum: 30 }
  validates :community_content, length: { maximum: 100 }

  geocoded_by :community_place do |obj, results|
    unless results.first
      obj.community_place = nil
    end
  end

  def self.community_user_create(user_id, community_id)
    CommunityUser.create(
      user_id: user_id,
      community_id: community_id
    )
  end

  def self.enterCommunity(user_id, community_id)
    community = Community.find(community_id)
    community_users = community.community_users.all
      if community.community_limit >= Date.today && community.community_number_of_people > community_users.count && community_users.find_by(user_id: user_id).blank?
        CommunityUser.create(
          user_id: user_id,
          community_id: community_id
        )
        return community
      else
        return nil
      end
    end

end
