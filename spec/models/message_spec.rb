require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "有効な状態であること" do
    it "メッセージがありprivate_idが有効な状態であること" do
      user = create(:user)
      room = create(:room, private_id: user.id)
      expect(create(:message, room: room, user: room.user)).to be_valid
    end
    it "メッセージがありpost_idが有効な状態であること" do
      expect(create(:message, :post_message)).to be_valid
    end
    it "メッセージがありtournament_idが有効な状態であること" do
      expect(create(:message, :tournament_message)).to be_valid
    end
    it "メッセージがありcommunity_idが有効な状態であること" do
      expect(create(:message, :community_message)).to be_valid
    end
  end

  describe "空白のvalidate" do
    it "メッセージがなければ無効な状態であること" do
      message = build(:message, :post_message, message_content: nil)
      message.valid?
      expect(message.errors[:message_content]).to include("を入力してください")
    end
    it "ユーザーがなければ無効な状態であること" do
      message = build(:message, :post_message, user_id: nil)
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください")
    end
    it "部屋がなければ無効な状態であること" do
      message = build(:message, :post_message, room_id: nil)
      message.valid?
      expect(message.errors[:room_id]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "メッセージが100文字以上ある場合無効な状態であること" do
      message = build(:message, :post_message, message_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      message.valid?
      expect(message.errors[:message_content]).to include("は100文字以内で入力してください")
    end
  end

  describe "message_errorメソッド" do
    context "private_idのとき" do
      it "privateを返す" do
        user = create(:user)
        room = create(:room, private_id: user.id)
        message = create(:message,room: room, user: room.user)
        expect(Message.message_error(message)).to eq "private"
      end
    end
    context "post_idのとき" do
      it "postを返す" do
        message = create(:message, :post_message)
        expect(Message.message_error(message)).to eq "post"
      end
    end
    context "tournament_idのとき" do
      it "tournamentを返す" do
        message = create(:message, :tournament_message)
        expect(Message.message_error(message)).to eq "tournament"
      end
    end
    context "community_idのとき" do
      it "communityを返す" do
        message = create(:message, :community_message)
        expect(Message.message_error(message)).to eq "community"
      end
    end
  end
end
