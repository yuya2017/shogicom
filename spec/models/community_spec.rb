require 'rails_helper'

RSpec.describe Community, type: :model do
  describe "有効な状態であること" do
    it "開催場所、応募期日、開催日時、参加費があれば有効な状態であること" do
      expect(create(:community)).to be_valid
    end
    it "応募人数はなくても有効な状態であること" do
      expect(create(:community, community_number_of_people: nil)).to be_valid
    end
  end

  describe "空白のvalidate" do
    it "開催場所がなければ無効な状態であること" do
      community = build(:community, community_place: nil)
      community.valid?
      expect(community.errors[:community_place]).to include("を入力してください")
    end
    it "応募期日がなければ無効な状態であること" do
      community = build(:community, community_limit: nil)
      community.valid?
      expect(community.errors[:community_limit]).to include("を入力してください")
    end
    it "開催日時がなければ無効な状態であること" do
      community = build(:community, community_date: nil)
      community.valid?
      expect(community.errors[:community_date]).to include("を入力してください")
    end
    it "参加費がなければ無効な状態であること" do
      community = build(:community, community_money: nil)
      community.valid?
      expect(community.errors[:community_money]).to include("を入力してください")
    end
    it "ユーザーがなければ無効な状態であること" do
      community = build(:community, user_id: nil)
      community.valid?
      expect(community.errors[:user_id]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "タグが51文字以上ある場合無効な状態であること" do
      community = build(:community, community_all_tag: "123456789012345678901234567890123456789012345678901")
      community.valid?
      expect(community.errors[:community_all_tag]).to include("は50文字以内で入力してください")
    end
    it "募集内容が101文字以上ある場合無効な状態であること" do
      community = build(:community, community_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      community.valid?
      expect(community.errors[:community_content]).to include("は100文字以内で入力してください")
    end
    it "応募人数は2人以上であるとき無効な状態であること" do
      community = build(:community, community_number_of_people: 1)
      community.valid?
      expect(community.errors[:community_number_of_people]).to include("は1より大きい値にしてください")
    end
  end

  describe "住所のvalidate" do
    it "存在しない住所の場合無効な状態であること" do
      community = build(:community, community_place: "ｊふぃあじおｆじあえｗｆ")
      community.valid?
      expect(community.errors[:community_place]).to include("が存在しない住所になっています。")
    end
  end

  describe "期日のvalidate" do
    context "応募期間は今日より後でないと無効な状態であること" do
      it "今日より前の場合無効な状態であること" do
        community = build(:community, :limit_before)
        community.valid?
        expect(community.errors[:community_limit]).to include("は今日以降にしてください。")
      end
      it "今日の場合は有効な状態あること" do
        expect(create(:community, :limit_today)).to be_valid
      end
    end
    context "開催日時は応募期間よりも後でないと無効な状態であること" do
      it "開催日時が応募期間よりも後の場合無効な状態であること" do
        community = build(:community, :date_before)
        community.valid?
        expect(community.errors[:community_date]).to include("は応募期間より後にしてください")
      end
      it "開催日時と応募期日が同じ日時の場合は有効な状態であること" do
        expect(create(:community, :date_same_limit)).to be_valid
      end
    end
  end

  describe "メソッド" do
    it "community_user_createメソッド" do
      community = create(:community)
      expect{ Community.community_user_create(community.user.id, community.id) }.to change{ CommunityUser.count }.by (1)
    end
    describe "イベントへの参加" do
      before do
        @user = create(:user)
      end
      context "enterCommunityメソッドでCommunityUserが増えること" do
        it "応募人数を超えておらず、応募期日内" do
          community = create(:community)
          Community.community_user_create(community.user.id, community.id)
          expect{ Community.enterCommunity(@user.id, community.id) }.to change{ CommunityUser.count }.by(1)
        end
      end
      context "enterCommunityメソッドでCommunityUserが増えないこと" do
        it "応募人数を超えていた場合" do
          @user2 = create(:user)
          community = create(:community, community_number_of_people: 2)
          Community.community_user_create(community.user.id, community.id)
          Community.enterCommunity(@user.id, community.id)
          expect{ Community.enterCommunity(@user2.id, community.id) }.to change{ CommunityUser.count }.by(0)
        end
        it "応募期日を過ぎた場合" do
          community = build(:community, community_limit: "2020/02/22".to_time)
          community.save(validate: false)
          Community.community_user_create(community.user.id, community.id)
          expect{ Community.enterCommunity(@user.id, community.id) }.to change{ CommunityUser.count }.by(0)
        end
        it "同じ大会に同じ人が参加してきた場合" do
          community = create(:community)
          Community.community_user_create(community.user.id, community.id)
          Community.enterCommunity(@user.id, community.id)
          expect{ Community.enterCommunity(@user.id, community.id) }.to change{CommunityUser.count }.by(0)
        end
      end
    end
  end
end
