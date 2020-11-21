require 'rails_helper'

RSpec.describe CommunityUser, type: :model do
  let(:community) { create(:community) }
  
  context "user_idとcommunity_idが存在する場合" do
    it "有効な状態であること" do
      community_user = CommunityUser.new(
        community_id: community.id,
        user_id: community.user.id
      )
      expect(community_user).to be_valid
    end
  end
  context "user_idが存在しない場合" do
    it "無効な状態であること" do
      community_user = CommunityUser.new(user_id: nil)
      community_user.valid?
      expect(community_user.errors[:user_id]).to include("を入力してください")
    end
  end
  context "community_idが存在しない場合" do
    it "無効な状態であること" do
      community_user = CommunityUser.new(community_id: nil)
      community_user.valid?
      expect(community_user.errors[:community_id]).to include("を入力してください")
    end
  end
end
