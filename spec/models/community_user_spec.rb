require 'rails_helper'

RSpec.describe CommunityUser, type: :model do
  before do
    @community = create(:community)
  end
  describe "有効な状態であること" do
    it "userとcommunityがあれば有効な状態であること" do
      community_user = CommunityUser.new(
        community_id: @community.id,
        user_id: @community.user.id
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
