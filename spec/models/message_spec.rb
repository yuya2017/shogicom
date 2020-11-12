require 'rails_helper'

RSpec.describe Message, type: :model do
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
  end
  describe "有効な状態であること" do
    before do
      @room = Room.create(
        room_name: "テスト１",
        user: @user
      )
    end
    it "メッセージがあれば有効な状態であること" do
      message = Message.new(
        message_content: "こんにちは",
        room: @room,
        user: @user
      )
      expect(message).to be_valid
    end
  end

  describe "空白のvalidate" do
    before do
      @room = Room.create(
        room_name: "テスト１",
        user: @user
      )
    end
    it "メッセージがなければ無効な状態であること" do
      message = Message.new(message_content: nil)
      message.valid?
      expect(message.errors[:message_content]).to include("を入力してください")
    end
    it "ユーザーがなければ無効な状態であること" do
      message = Message.new(user_id: nil)
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください")
    end
    it "部屋がなければ無効な状態であること" do
      message = Message.new(room_id: nil)
      message.valid?
      expect(message.errors[:room_id]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    before do
      @room = Room.create(
        room_name: "テスト１",
        user: @user
      )
    end
    it "メッセージが100文字以上ある場合無効な状態であること" do
      message = Message.new(message_content: "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901")
      message.valid?
      expect(message.errors[:message_content]).to include("は100文字以内で入力してください")
    end
  end

  describe "message_errorメソッド" do
    context "private_idのとき" do
      it "privateを返す" do
        private_room = Room.create(
          room_name: "テスト１",
          private_id: 1,
          user: @user
        )
        message = Message.new(
          message_content: "こんにちは",
          user: @user,
          room: private_room
        )
        expect(Message.message_error(message)).to eq "private"
      end
    end
    context "post_idのとき" do
      it "postを返す" do
        post = Post.create(
          post_chess: "30級",
          post_app: "将棋",
          post_time: "10分",
          user: @user
        )
        post_room = Room.create(
          room_name: "テスト１",
          post_id: post.id,
          user: @user
        )
        message = Message.new(
          message_content: "こんにちは",
          user: @user,
          room: post_room
        )
        expect(Message.message_error(message)).to eq "post"
      end
    end
    context "tournament_idのとき" do
      it "tournamentを返す" do
        tournament = Tournament.create(
          tournament_chess: "30級",
          tournament_app: "将棋",
          tournament_time: "10分",
          tournament_time: "10分",
          tournament_limit: "2022/02/22".to_time,
          tournament_at_date: "2022/02/25",
          tournament_at_hour: "12",
          tournament_at_minute: "30",
          user: @user
        )
        tournament_room = Room.create(
          room_name: "テスト１",
          tournament_id: tournament.id,
          user: @user
        )
        message = Message.new(
          message_content: "こんにちは",
          user: @user,
          room: tournament_room
        )
        expect(Message.message_error(message)).to eq "tournament"
      end
    end
    context "community_idのとき" do
      it "communityを返す" do
        community = Community.create(
          community_place: "東京都",
          community_limit: "2022/02/22".to_time,
          community_date: "2022/02/25".to_time,
          community_money: 0,
          user: @user
        )
        community_room = Room.create(
          room_name: "テスト１",
          community_id: community.id,
          user: @user
        )
        message = Message.new(
          message_content: "こんにちは",
          user: @user,
          room: community_room
        )
        expect(Message.message_error(message)).to eq "community"
      end
    end
  end
end
