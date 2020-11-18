require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "有効な状態であること" do
    it "名前がありprivate_idがあれば有効な状態であること" do
      user = create(:user)
      expect(create(:room, private_id: user.id)).to be_valid
    end
    it "名前がありpost_idがあれば有効な状態であること" do
      expect(create(:room, :post_room)).to be_valid
    end
    it "名前がありtournament_idがあれば有効な状態であること" do
      expect(create(:room, :tournament_room)).to be_valid
    end
    it "名前がありcommunity_idがあれば有効な状態であること" do
      expect(create(:room, :community_room)).to be_valid
    end
  end
  describe "空白のvalidate"  do
    it "名前がなければ無効な状態であること" do
      room = build(:room, :post_room, room_name: nil)
      room.valid?
      expect(room.errors[:room_name]).to include("を入力してください")
    end
  end

  describe "文字数制限のvalidate" do
    it "名前が11文字以上ある場合無効な状態であること" do
      room = build(:room, :post_room, room_name: "12345678901")
      room.valid?
      expect(room.errors[:room_name]).to include("は10文字以内で入力してください")
    end
  end

  describe "メソッド" do
    before do
      @user = create(:user)
    end
    context "enterRoomメソッドで部屋が増える" do
      it "private_roomが無い状態" do
        @user2 = create(:user)
        expect{ Room.enterRoom(@user.id, @user2.id) }.to change { Room.count }.by(1)
      end
    end
    context "enterRoomメソッドで部屋が増えない" do
      before do
        @user2 = create(:user)
        Room.enterRoom(@user.id, @user2.id)
      end
      it "private_roomがある状態" do
        expect{ Room.enterRoom(@user.id, @user2.id) }.to change { Room.count }.by(0)
      end
      it "user_idとprivate_idが逆" do
        expect{ Room.enterRoom(@user2.id, @user.id) }.to change { Room.count }.by(0)
      end
    end

    describe "my_private_room" do
      before do
        @user2 = create(:user)
        @private_room = create(:room, user: @user, private_id: @user2.id)
        @rooms = Room.all
      end
      context "my_private_roomメソッドで部屋がありメッセージもある場合" do
        it "private_messagesとmessage_usersが増える(自分)" do
          message = Message.create(
            message_content: "こんにちは",
            user: @user,
            room: @private_room
          )
          private_messages, message_users, no_messages, no_message_users = Room.my_private_room(@rooms, @user)
          expect(private_messages.size).to eq 1
          expect(message_users.size).to eq 1
        end
        it "private_messagesとmessage_usersが増える(相手)" do
          message = Message.create(
            message_content: "こんにちは",
            user: @user,
            room: @private_room
          )
          private_messages, message_users, no_messages, no_message_users = Room.my_private_room(@rooms, @user2)
          expect(private_messages.size).to eq 1
          expect(message_users.size).to eq 1
        end
      end
      context "my_private_roomメソッドで部屋がありメッセージがない場合" do
        it "no_messagesとno_message_usersが増える(自分)" do
          private_messages, message_users, no_messages, no_message_users = Room.my_private_room(@rooms, @user)
          expect(no_messages.size).to eq 1
          expect(no_message_users.size).to eq 1
        end
        it "no_messagesとno_message_usersが増える(相手)" do
          private_messages, message_users, no_messages, no_message_users = Room.my_private_room(@rooms, @user2)
          expect(no_messages.size).to eq 1
          expect(no_message_users.size).to eq 1
        end
      end
    end
    context "my_post_roomメソッドで部屋がありメッセージもある場合" do
      it "post_messagesが増える" do
        post_room = create(:room, :post_room, user: @user)
        create(:message, room: post_room, user: @user)
        messages = @user.messages
        posts = @user.posts
        post_messages,no_message_posts = Room.my_post_room(messages, posts)
        expect(post_messages.size).to eq 1
      end
    end
    context "my_post_roomメソッドで部屋がありメッセージがない場合" do
      it "no_message_postsが増える" do
        post = create(:post, user: @user)
        post_room = create(:room, :post_room, post: post)
        messages = @user.messages
        posts = @user.posts
        post_messages,no_message_posts = Room.my_post_room(messages, posts)
        expect(no_message_posts.size).to eq 1
      end
    end
    context "my_tournament_roomメソッドで部屋がありメッセージもある場合" do
      it "tournament_messagesが増える" do
        tournament_room = create(:room, :tournament_room, user: @user)
        TournamentUser.create(user: @user, tournament: tournament_room.tournament )
        create(:message, room: tournament_room, user: @user)
        tournament_users = @user.tournament_users.all
        tournament_messages, tournament_no_messages = Room.my_tournament_room(tournament_users)
        expect(tournament_messages.size).to eq 1
      end
    end
    context "my_tournament_roomメソッドで部屋がありメッセージがない場合" do
      it "tournament_no_messagesが増えること" do
        tournament_room = create(:room, :tournament_room, user: @user)
        TournamentUser.create(user: @user, tournament: tournament_room.tournament )
        tournament_users = @user.tournament_users.all
        tournament_messages, tournament_no_messages = Room.my_tournament_room(tournament_users)
        expect(tournament_no_messages.size).to eq 1
      end
    end
    context "my_community_roomメソッドで部屋がありメッセージもある場合" do
      it "community_messagesが増える" do
        community_room = create(:room, :community_room, user: @user)
        CommunityUser.create(user: @user, community: community_room.community )
        create(:message, room: community_room, user: @user)
        community_users = @user.community_users.all
        community_messages, community_no_messages = Room.my_community_room(community_users)
        expect(community_messages.size).to eq 1
      end
    end
    context "my_community_roomメソッドで部屋がありメッセージがない場合" do
      it "community_no_messagesが増えること" do
        community_room = create(:room, :community_room, user: @user)
        CommunityUser.create(user: @user, community: community_room.community )
        community_users = @user.community_users.all
        community_messages, community_no_messages = Room.my_community_room(community_users)
        expect(community_no_messages.size).to eq 1
      end
    end
  end
end
