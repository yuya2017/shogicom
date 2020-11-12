require 'rails_helper'

RSpec.describe CommunityUser, type: :model do
  before do
    @user = User.create(
      user_name: "木下侑哉",
      email: "tester@example.com",
      user_chess: "30級",
      user_app: "将棋",
      user_time: "10分",
      user_pref: 13,
      password: "password",
      confirmed_at: Time.now
    )
    @community = Community.create(
      community_place: "東京都",
      community_limit: "2022/02/22".to_time,
      community_date: "2022/02/25".to_time,
      community_money: 0,
      user: @user
    )
  end
  describe "有効な状態であること" do
    it "userとcommunityがあれば有効な状態であること" do
      community_user = CommunityUser.new(
        community_id: @community.id,
        user_id: @user.id
      )
      expect(community_user).to be_valid
    end
  end
  describe "無効な状態であること" do
    it "userがなければ無効な状態であること" do
      community_user = CommunityUser.new(user_id: nil)
      community_user.valid?
      expect(community_user.errors[:user_id]).to include("を入力してください")
    end
    it "tournamentがなければ無効な状態であること" do
      community_user = CommunityUser.new(community_id: nil)
      community_user.valid?
      expect(community_user.errors[:community_id]).to include("を入力してください")
    end
  end
end
