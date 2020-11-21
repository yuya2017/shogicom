require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:private_room) { create(:room, user_id: user.id, private_id: user2.id) }
  let(:post_room) { create(:room, :post_room) }
  let(:tournament_room) { create(:room, :tournament_room) }
  let(:community_room) { create(:room, :community_room) }
  let(:rooms) { Room.all }
  
  context "room_name,user_id,private_idが存在する場合" do
    it "有効な状態であること" do
      expect(create(:room, private_id: user.id)).to be_valid
    end
  end
  context "room_name,user_id,post_idが存在する場合" do
    it "有効な状態であること" do
      expect(create(:room, :post_room)).to be_valid
    end
  end
  context "room_name,user_id,tournament_idが存在する場合" do
    it "有効な状態であること" do
      expect(create(:room, :tournament_room)).to be_valid
    end
  end
  context "room_name,user_id,community_idが存在する場合" do
    it "有効な状態であること" do
      expect(create(:room, :community_room)).to be_valid
    end
  end

  describe "空白のvalidate"  do
    context "user_nameが存在しない場合" do
      it "無効な状態であること" do
        room = build(:room, :post_room, room_name: nil)
        room.valid?
        expect(room.errors[:room_name]).to include("を入力してください")
      end
    end
  end

  describe "文字数制限のvalidate" do
    context "room_nameが11文字以上の場合" do
      it "無効な状態であること" do
        room = build(:room, :post_room, room_name: "12345678901")
        room.valid?
        expect(room.errors[:room_name]).to include("は10文字以内で入力してください")
      end
    end
  end

  describe "enterRoomメソッド" do
    context "private_idがまだ生成されていない場合" do
      it "Roomが増えること" do
        expect{ Room.enterRoom(user.id, user2.id) }.to change { Room.count }.by(1)
      end
    end
    context "private_idがすでに生成されている場合" do
      it "Roomは増えないこと" do
        create(:room, user: user, private_id: user2.id)
        expect{ Room.enterRoom(user.id, user2.id) }.to change { Room.count }.by(0)
      end
    end
    context "user_idとprivate_idが逆の場合" do
      it "Roomは増えないこと" do
        create(:room, user: user, private_id: user2.id)
        expect{ Room.enterRoom(user2.id, user.id) }.to change { Room.count }.by(0)
      end
    end
  end

  describe "my_private_room" do
    context "部屋がありメッセージもある場合" do
      it "自分のprivate_messagesとmessage_usersが増える" do
        create(:message, user: user, room: private_room)
        private_messages, message_users, no_messages, no_message_users = Room.my_private_room(rooms, user)
        expect(private_messages.size).to eq 1
        expect(message_users.size).to eq 1
      end
      it "相手のprivate_messagesとmessage_usersが増える" do
        create(:message, user: user, room: private_room)
        private_messages, message_users, no_messages, no_message_users = Room.my_private_room(rooms, user2)
        expect(private_messages.size).to eq 1
        expect(message_users.size).to eq 1
      end
    end
    context "my_private_roomメソッドで部屋がありメッセージがない場合" do
      it "自分のno_messagesとno_message_usersが増える" do
        create(:room, user_id: user.id, private_id: user2.id)
        private_messages, message_users, no_messages, no_message_users = Room.my_private_room(rooms, user)
        expect(no_messages.size).to eq 1
        expect(no_message_users.size).to eq 1
      end
      it "相手のno_messagesとno_message_usersが増える" do
        create(:room, user_id: user.id, private_id: user2.id)
        private_messages, message_users, no_messages, no_message_users = Room.my_private_room(rooms, user2)
        expect(no_messages.size).to eq 1
        expect(no_message_users.size).to eq 1
      end
    end
  end

  describe "my_post_room" do
    context "my_post_roomメソッドで部屋がありメッセージもある場合" do
      it "post_messagesが増える" do
        create(:message, room: post_room, user: User.first)
        messages = User.first.messages
        posts = User.first.posts
        post_messages,no_message_posts = Room.my_post_room(messages, posts)
        expect(post_messages.size).to eq 1
      end
    end
    context "my_post_roomメソッドで部屋がありメッセージがない場合" do
      it "no_message_postsが増える" do
        create(:room, :post_room)
        messages = User.first.messages
        posts = User.first.posts
        post_messages,no_message_posts = Room.my_post_room(messages, posts)
        expect(no_message_posts.size).to eq 1
      end
    end
  end

  describe "my_tournament_roomメソッド" do
    context "部屋がありメッセージもある場合" do
      it "tournament_messagesが増える" do
        create(:message, room: tournament_room, user: User.first)
        TournamentUser.create(user: User.first, tournament: tournament_room.tournament )
        tournament_users = User.first.tournament_users.all
        tournament_messages, tournament_no_messages = Room.my_tournament_room(tournament_users)
        expect(tournament_messages.size).to eq 1
      end
    end
    context "部屋がありメッセージがない場合" do
      it "tournament_no_messagesが増えること" do
        create(:room, :tournament_room)
        TournamentUser.create(user: User.first, tournament: Tournament.first )
        tournament_users = User.first.tournament_users.all
        tournament_messages, tournament_no_messages = Room.my_tournament_room(tournament_users)
        expect(tournament_no_messages.size).to eq 1
      end
    end
  end

  describe "my_community_roomメソッド" do
    context "部屋がありメッセージもある場合" do
      it "community_messagesが増える" do
        create(:message, room: community_room, user: User.first)
        CommunityUser.create(user: User.first, community: community_room.community )
        community_users = User.first.community_users.all
        community_messages, community_no_messages = Room.my_community_room(community_users)
        expect(community_messages.size).to eq 1
      end
    end
    context "部屋がありメッセージがない場合" do
      it "community_no_messagesが増えること" do
        create(:room, :community_room)
        CommunityUser.create(user: User.first, community: Community.first )
        community_users = User.first.community_users.all
        community_messages, community_no_messages = Room.my_community_room(community_users)
        expect(community_no_messages.size).to eq 1
      end
    end
  end
end
