require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "有効な状態であること" do
    it "名前があれば有効な状態であること、" do
      room = Room.new(
        room_name: "テスト１",
        user: @user
      )
      expect(room).to be_valid
    end
  end
  describe "空白のvalidate"  do
    it "名前がなければ無効な状態であること" do
      room = Room.new(room_name: nil)
      room.valid?
      expect(room.errors[:room_name]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "名前が11文字以上ある場合無効な状態であること" do
      room = Room.new(room_name: "12345678901")
      room.valid?
      expect(room.errors[:room_name]).to include("は10文字以内で入力してください")
    end
  end

  describe "メソッド" do
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
      @post = Post.create(
        post_chess: "30級",
        post_app: "将棋",
        post_time: "10分",
        user: @user
      )
      @post_room = Room.create(
        room_name: "オンライン対戦",
        user: @user,
        post: @post
      )
      @tournament = Tournament.create(
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
      @tournament_room = Room.create(
        room_name: "大会",
        user: @user,
        tournament: @tournament
      )
      Tournament.tournament_user_create(@user.id, @tournament.id)
      @community = Community.create(
        community_place: "東京都",
        community_limit: "2022/02/22".to_time,
        community_date: "2022/02/25".to_time,
        community_money: 0,
        user: @user
      )
      Community.community_user_create(@user.id, @community.id)
      @community_room = Room.create(
        room_name: "イベント",
        user: @user,
        community: @community
      )
      @user2 = User.create(
        user_name: "鈴木太郎",
        email: "tester2@example.com",
        user_chess: "30級",
        user_app: "将棋",
        user_time: "10分",
        user_pref: 13,
        password: "password",
        confirmed_at: Time.now
      )
    end
    context "enterRoomメソッドでprivate_roomがない状態" do
      it "新しい部屋を作成する" do
        expect{ Room.enterRoom(@user.id, @user2.id) }.to change { Room.count }.by(1)
      end
    end
    context "enterRoomメソッドでprivate_roomがある状態" do
      before do
        Room.enterRoom(@user.id, @user2.id)
      end
      it "新しい部屋はつくらない" do
        expect{ Room.enterRoom(@user.id, @user2.id) }.to change { Room.count }.by(0)
      end
      it "user_idとprivate_idが逆" do
        expect{ Room.enterRoom(@user2.id, @user.id) }.to change { Room.count }.by(0)
      end
    end
    context "my_private_roomメソッドで部屋がありメッセージもある場合" do
      it "private_messagesとmessage_usersが増える" do
        @private_room = Room.create(
          room_name: "個人用チャットルーム",
          user_id: @user.id,
          private_id: @user2.id
        )
        @rooms = Room.all
        message = Message.create(
          message_content: "こんにちは",
          user: @user,
          room: @private_room
        )
        private_messages, message_users, no_messages, no_message_users = Room.my_private_room(@rooms, @user)
        expect(private_messages.size).to eq 1
        expect(message_users.size).to eq 1
      end
    end
    context "my_private_roomメソッドで部屋がありメッセージがない場合" do
      it "no_messagesとno_message_usersが増える" do
        @private_room = Room.create(
          room_name: "個人用チャットルーム",
          user_id: @user.id,
          private_id: @user2.id
        )
        @rooms = Room.all
        private_messages, message_users, no_messages, no_message_users = Room.my_private_room(@rooms, @user)
        expect(no_messages.size).to eq 1
        expect(no_message_users.size).to eq 1
      end
    end
    context "my_post_roomメソッド" do
      it "my_post_roomで部屋が増えること" do
        Message.create(
          message_content:"こんにちは",
          user: @user,
          room: @post_room
        )
        messages = @user.messages
        post_messages = Room.my_post_room(messages)
        expect(post_messages.size).to eq 1
      end
    end
    context "my_tournament_roomメソッドで部屋がありメッセージもある場合" do
      it "tournament_messagesが増える" do
        Message.create(
          message_content: "こんにちは",
          user: @user,
          room: @tournament_room
        )
        tournament_users = @user.tournament_users.all
        tournament_messages, tournament_no_messages = Room.my_tournament_room(tournament_users)
        expect(tournament_messages.size).to eq 1
      end
    end
    context "my_tournament_roomメソッドで部屋がありメッセージがない場合" do
      it "tournament_no_messagesが増えること" do
        tournament_users = @user.tournament_users.all
        tournament_messages, tournament_no_messages = Room.my_tournament_room(tournament_users)
        expect(tournament_no_messages.size).to eq 1
      end
    end
    context "my_community_roomメソッドで部屋がありメッセージもある場合" do
      it "community_messagesが増える" do
        Message.create(
          message_content: "こんにちは",
          user: @user,
          room: @community_room
        )
        community_users = @user.community_users.all
        community_messages, community_no_messages = Room.my_community_room(community_users)
        expect(community_messages.size).to eq 1
      end
    end
    context "my_community_roomメソッドで部屋がありメッセージがない場合" do
      it "community_no_messagesが増えること" do
        community_users = @user.community_users.all
        community_messages, community_no_messages = Room.my_community_room(community_users)
        expect(community_no_messages.size).to eq 1
      end
    end
    context "my_community_roomメソッドで部屋がありメッセージがない場合" do
      it "my_post_roomで部屋が増えること" do
        Message.create(
          message_content:"こんにちは",
          user: @user,
          room: @post_room
        )
        messages = @user.messages
        post_messages = Room.my_post_room(messages)
        expect(post_messages.size).to eq 1
      end
    end
  end
end
