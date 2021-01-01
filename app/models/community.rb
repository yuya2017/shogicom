class Community < ApplicationRecord

  belongs_to :user
  has_many :community_users, dependent: :destroy
  has_one :room, dependent: :destroy
  accepts_nested_attributes_for :room

  before_validation :geocode
  validates :community_place, presence: true
  validates :community_limit, presence: true
  validates :community_date, presence: true
  validates :community_money, presence: true
  validates :community_number_of_people, numericality: { greater_than: 1 }, allow_nil: true
  validates :user_id, presence: true
  validates :community_all_tag, length: { maximum: 50 }
  validates :community_content, length: { maximum: 100 }
  validate  :community_place_reality
  validate  :limit_not_before_today
  validate  :date_not_before_limit

  geocoded_by :community_place do |obj, results|
    if obj.community_place == "" || obj.community_place == nil
      obj.community_place == nil
    elsif results.first.nil?
      obj.community_place = "存在しません"
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

  def self.communityMap
    communities =  Community.where("community_limit >= ?", Date.today)
    communitues_map = []
    communities.each do |community|
      participant = community.community_users.all
      if community.community_number_of_people.nil? || community.community_number_of_people > participant.count
        communitues_map.push(community)
      end
    end
    return communitues_map
  end

  private

  def community_place_reality
    errors.add(:community_place, "が存在しない住所になっています。") if community_place == "存在しません"
  end

  def limit_not_before_today
    if community_limit.present?
      if community_limit < Date.today
        errors.add(:community_limit, "は今日以降にしてください。")
      end
    end
  end

  def date_not_before_limit
    if community_date.present? && community_limit.present?
      if community_date < community_limit
        errors.add(:community_date, "は応募期間より後にしてください")
      end
    end
  end

end
