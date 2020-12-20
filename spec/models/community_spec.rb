require 'rails_helper'

RSpec.describe Community, type: :model do
  let(:user) { create(:user) }
  let(:community) { create(:community) }

  context "community_place,community_limit,community_date,community_money,community_number_of_peopleが存在する場合" do
    it "有効な状態であること" do
      expect(community).to be_valid
    end
    context "community_number_of_peopleが存在しない場合"
    it "有効な状態であること" do
      expect(create(:community, community_number_of_people: nil)).to be_valid
    end
  end

  describe "空白のvalidate" do
    context "community_placeが存在しない場合" do
      it "無効な状態であること" do
        community = build(:community, community_place: nil)
        community.valid?
        expect(community.errors[:community_place]).to include("を入力してください")
      end
    end
    context "community_limitが存在しない場合" do
      it "無効な状態であること" do
        community = build(:community, community_limit: nil)
        community.valid?
        expect(community.errors[:community_limit]).to include("を入力してください")
      end
    end
    context "community_dateが存在しない場合" do
      it "無効な状態であること" do
        community = build(:community, community_date: nil)
        community.valid?
        expect(community.errors[:community_date]).to include("を入力してください")
      end
    end
    context "community_moneyが存在しない場合" do
      it "無効な状態であること" do
        community = build(:community, community_money: nil)
        community.valid?
        expect(community.errors[:community_money]).to include("を入力してください")
      end
    end
    context "user_idが存在しない場合"
    it "無効な状態であること" do
      community = build(:community, user_id: nil)
      community.valid?
      expect(community.errors[:user_id]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    context "community_all_tagが51文字以上の場合" do
      it "無効な状態であること" do
        community = build(:community, community_all_tag: "123456789012345678901234567890123456789012345678901")
        community.valid?
        expect(community.errors[:community_all_tag]).to include("は50文字以内で入力してください")
      end
    end
    context "community_contentが101文字以上の場合" do
      it "無効な状態であること" do
        community = build(:community, community_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
        community.valid?
        expect(community.errors[:community_content]).to include("は100文字以内で入力してください")
      end
    end
    context "community_placeが2人未満の場合"
    it "応募人数は2人以上であるとき無効な状態であること" do
      community = build(:community, community_number_of_people: 1)
      community.valid?
      expect(community.errors[:community_number_of_people]).to include("は1より大きい値にしてください")
    end
  end

  describe "住所のvalidate" do
    context "community_placeがの住所が存在しない場合" do
      it "無効な状態であること" do
        community = build(:community, community_place: "ｊふぃあじおｆじあえｗｆ")
        community.valid?
        expect(community.errors[:community_place]).to include("が存在しない住所になっています。")
      end
    end
  end

  describe "期日のvalidate" do
    context "応募期間が今日より前の場合" do
      it "無効な状態であること" do
        community = build(:community, :limit_before)
        community.valid?
        expect(community.errors[:community_limit]).to include("は今日以降にしてください。")
      end
    end
    context "応募期間が今日の場合" do
      it "有効な状態あること" do
        expect(create(:community, :limit_today)).to be_valid
      end
    end
    context "開催日時が応募期間よりも前の日場合" do
      it "無効な状態であること" do
        community = build(:community, :date_before)
        community.valid?
        expect(community.errors[:community_date]).to include("は応募期間より後にしてください")
      end
    end
    context "開催日時と応募期日が同じ日時の場合" do
      it "有効な状態であること" do
        expect(create(:community, :date_same_limit)).to be_valid
      end
    end
  end

  describe "community_user_createメソッド" do
    it "CommunityUserが生成されること" do
      expect{ Community.community_user_create(community.user.id, community.id) }.to change{ CommunityUser.count }.by(1)
    end
  end

  describe "enterCommunityメソッド" do
    context "応募人数を超えておらず、応募期日内の場合" do
      it "CommunityUserが生成されること" do
        community = create(:community)
        Community.community_user_create(community.user.id, community.id)
        expect{ Community.enterCommunity(user.id, community.id) }.to change{ CommunityUser.count }.by(1)
      end
    end
    context "応募人数を超えていた場合" do
      it "CommunityUserが生成されないこと" do
        user2 = create(:user)
        community = create(:community, community_number_of_people: 2)
        Community.community_user_create(community.user.id, community.id)
        Community.enterCommunity(user.id, community.id)
        expect{ Community.enterCommunity(user2.id, community.id) }.to change{ CommunityUser.count }.by(0)
      end
    end
    context "応募期日を過ぎた場合" do
      it "CommunityUserが生成されないこと" do
        community = build(:community, community_limit: "2020/02/22".to_time)
        community.save(validate: false)
        Community.community_user_create(community.user.id, community.id)
        expect{ Community.enterCommunity(user.id, community.id) }.to change{ CommunityUser.count }.by(0)
      end
    end
    context "同じイベントに同じ人が参加してきた場合" do
      it "CommunityUserが生成されないこと" do
        Community.community_user_create(community.user.id, community.id)
        Community.enterCommunity(user.id, community.id)
        expect{ Community.enterCommunity(user.id, community.id) }.to change{CommunityUser.count }.by(0)
      end
    end
  end
end
