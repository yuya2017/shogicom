require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:private_room) { create(:room, private_id: user.id) }
  let(:post_message) { create(:message, :post_message) }
  let(:tournament_message) { create(:message, :tournament_message) }
  let(:community_message) { create(:message, :community_message) }
  
  context "message_content,user_id,private_idが存在する場合" do
    it "有効な状態であること" do
      user = create(:user)
      room = create(:room, private_id: user.id)
      expect(create(:message, room: room, user: room.user)).to be_valid
    end
  end
  context "message_content,user_id,room_id(post)が存在する場合" do
    it "有効な状態であること" do
      expect(create(:message, :post_message)).to be_valid
    end
  end
  context "message_content,user_id,room_id(tournament)が存在する場合" do
    it "有効な状態であること" do
      expect(create(:message, :tournament_message)).to be_valid
    end
  end
  context "message_content,user_id,room_id(community)が存在する場合" do
    it "メッセージがありcommunity_idが有効な状態であること" do
      expect(create(:message, :community_message)).to be_valid
    end
  end

  describe "空白のvalidate" do
    context "message_contentが存在しない場合" do
      it "無効な状態であること" do
        message = build(:message, :post_message, message_content: nil)
        message.valid?
        expect(message.errors[:message_content]).to include("を入力してください")
      end
    end
    context "user_idが存在しない場合" do
      it "無効な状態であること" do
        message = build(:message, :post_message, user_id: nil)
        message.valid?
        expect(message.errors[:user_id]).to include("を入力してください")
      end
    end
    context "room_idが存在しない場合" do
      it "無効な状態であること" do
        message = build(:message, :post_message, room_id: nil)
        message.valid?
        expect(message.errors[:room_id]).to include("を入力してください")
      end
    end
  end

  describe "文字数制限のvalidate" do
    context "message_contentが101文字以上の場合" do
      it "無効な状態であること" do
        message = build(:message, :post_message, message_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
        message.valid?
        expect(message.errors[:message_content]).to include("は100文字以内で入力してください")
      end
    end
  end

  describe "message_errorメソッド" do
    context "private_idのとき" do
      it "privateを返す" do
        message = create(:message,room: private_room, user: User.first)
        expect(Message.message_error(message)).to eq "private"
      end
    end
    context "post_idのとき" do
      it "postを返す" do
        expect(Message.message_error(post_message)).to eq "post"
      end
    end
    context "tournament_idのとき" do
      it "tournamentを返す" do
        expect(Message.message_error(tournament_message)).to eq "tournament"
      end
    end
    context "community_idのとき" do
      it "communityを返す" do
        expect(Message.message_error(community_message)).to eq "community"
      end
    end
  end
end
