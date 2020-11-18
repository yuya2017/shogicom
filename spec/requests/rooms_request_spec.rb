require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  context "ログインしている状態" do
    before do
      @user = create(:user)
      sign_in @user
    end
    describe "#private_show" do
      it "正常なレスポンスを返すこと" do
        @user2 = create(:user)
        room = create(:room, private_id: @user2.id, user: @user)
        get "/rooms/#{room.id}/private"
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#post_show" do
      it "正常なレスポンスを返すこと" do
        post = create(:post, user: @user)
        room = create(:room, :post_room, post: post, user: @user)
        get "/rooms/#{room.id}/post"
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#tournament_show" do
      it "正常なレスポンスを返すこと" do
        tournament = create(:tournament, user: @user)
        TournamentUser.create(tournament: tournament, user: @user)
        room = create(:room, :tournament_room, tournament: tournament, user: @user)
        get "/rooms/#{room.id}/tournament"
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#community_show" do
      it "正常なレスポンスを返すこと" do
        community = create(:community, user: @user)
        CommunityUser.create(community: community, user: @user)
        room = create(:room, :community_room, community: community, user: @user)
        get "/rooms/#{room.id}/community"
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#create_private_room" do
      it "新しい部屋が作成されること" do
        @user2 = create(:user)
        expect {
          post rooms_create_private_room_path, params: { user_id: @user2.id }
        }.to change(Room, :count).by(1)
      end
    end
    describe "#private_message" do
      it "正常なレスポンスを返すこと" do
        get rooms_private_message_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#participating_post" do
      it "正常なレスポンスを返すこと" do
        get rooms_participating_post_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#participating_tournament" do
      it "正常なレスポンスを返すこと" do
        get rooms_participating_tournament_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#participating_community" do
      it "正常なレスポンスを返すこと" do
        get rooms_participating_community_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
  end
  context "ログインしていない状態" do
    before do
      @user = create(:user)
    end
    describe "#private_show" do
      it "302レスポンスを返すこと" do
        @user2 = create(:user)
        room = create(:room, private_id: @user2.id, user: @user)
        get "/rooms/#{room.id}/private"
        expect(response.status).to eq 302
      end
    end
    describe "#post_show" do
      it "302レスポンスを返すこと" do
        post = create(:post, user: @user)
        room = create(:room, :post_room, post: post, user: @user)
        get "/rooms/#{room.id}/post"
        expect(response.status).to eq 302
      end
    end
    describe "#tournament_show" do
      it "302レスポンスを返すこと" do
        tournament = create(:tournament, user: @user)
        TournamentUser.create(tournament: tournament, user: @user)
        room = create(:room, :tournament_room, tournament: tournament, user: @user)
        get "/rooms/#{room.id}/tournament"
        expect(response.status).to eq 302
      end
    end
    describe "#community_show" do
      it "302レスポンスを返すこと" do
        community = create(:community, user: @user)
        CommunityUser.create(community: community, user: @user)
        room = create(:room, :community_room, community: community, user: @user)
        get "/rooms/#{room.id}/community"
        expect(response.status).to eq 302
      end
    end
    describe "#create_private_room" do
      it "新しい部屋が作成されないこと" do
        @user2 = create(:user)
        expect {
          post rooms_create_private_room_path, params: { user_id: @user2.id }
        }.not_to change(Room, :count)
        expect(response.status).to eq 302
      end
    end
    describe "#private_message" do
      it "302レスポンスを返すこと" do
        get rooms_private_message_path
        expect(response.status).to eq 302
      end
    end
    describe "#participating_post" do
      it "302レスポンスを返すこと" do
        get rooms_participating_post_path
        expect(response.status).to eq 302
      end
    end
    describe "#participating_tournament" do
      it "302レスポンスを返すこと" do
        get rooms_participating_tournament_path
        expect(response.status).to eq 302
      end
    end
    describe "#participating_community" do
      it "302レスポンスを返すこと" do
        get rooms_participating_community_path
        expect(response.status).to eq 302
      end
    end
  end
end
