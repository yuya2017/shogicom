require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  context "ログインしている状態" do
    before do
      sign_in user
    end
    describe "#private_show" do
      let!(:room) { create(:room, private_id: user2.id, user: user) }
      context "routesがprivateの場合" do
        it "リクエストが成功すること" do
          get "/rooms/#{room.id}/private"
          aggregate_failures do
            expect(response).to be_successful
            expect(response.status).to eq 200
          end
        end
      end
      context "routesがpostの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/post"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがtournamentの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/tournament"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがcommunityの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/community"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#post_show" do
      let(:post) { create(:post, user: user) }
      let!(:room) { create(:room, :post_room, post: post, user: user) }
      context "routesがpostの場合" do
        it "リクエストが成功すること" do
          get "/rooms/#{room.id}/post"
          aggregate_failures do
            expect(response).to be_successful
            expect(response.status).to eq 200
          end
        end
      end
      context "routesがprivateの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/private"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがtournamentの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/tournament"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがcommunityの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/community"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#tournament_show" do
      let(:tournament) { create(:tournament, user: user) }
      let!(:room) { create(:room, :tournament_room, tournament: tournament, user: user) }
      let!(:tournament_user) { TournamentUser.create(tournament: tournament, user: user) }
      context "routesがtournamentの場合" do
        it "リクエストが成功すること" do
          get "/rooms/#{room.id}/tournament"
          aggregate_failures do
            expect(response).to be_successful
            expect(response.status).to eq 200
          end
        end
      end
      context "routesがprivateの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/private"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがpostの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/post"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがcommunityの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/community"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#community_show" do
      let(:community) { create(:community, user: user) }
      let!(:room) { create(:room, :community_room, community: community, user: user) }
      let!(:community_user) { CommunityUser.create(community: community, user: user) }
      context "routesがcommunityの場合" do
        it "リクエストが成功すること" do
          get "/rooms/#{room.id}/community"
          aggregate_failures do
            expect(response).to be_successful
            expect(response.status).to eq 200
          end
        end
      end
      context "routesがprivateの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/private"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがpostの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/post"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
      context "routesがtournamentの場合" do
        it "リダイレクトされること" do
          get "/rooms/#{room.id}/tournament"
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#create_private_room" do
      it "新しい部屋が作成されること" do
        expect {
          post rooms_create_private_room_path, params: { user_id: user2.id }
        }.to change(Room, :count).by(1)
      end
    end
    describe "#private_message" do
      it "リクエストが成功すること" do
        get rooms_private_message_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#participating_post" do
      it "リクエストが成功すること" do
        get rooms_participating_post_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#participating_tournament" do
      it "リクエストが成功すること" do
        get rooms_participating_tournament_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#participating_community" do
      it "リクエストが成功すること" do
        get rooms_participating_community_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
  end
  context "ログインしていない状態" do
    describe "#private_show" do
      it "リダイレクトされること" do
        room = create(:room, private_id: user2.id, user: user)
        get "/rooms/#{room.id}/private"
        expect(response.status).to eq 302
      end
    end
    describe "#post_show" do
      let(:post) { create(:post, user: user) }
      let!(:room) { create(:room, :post_room, post: post, user: user) }
      it "リダイレクトされること" do
        get "/rooms/#{room.id}/post"
        expect(response.status).to eq 302
      end
    end
    describe "#tournament_show" do
      let(:tournament) { create(:tournament, user: user) }
      let!(:room) { create(:room, :tournament_room, tournament: tournament, user: user) }
      let!(:tournament_user) { TournamentUser.create(tournament: tournament, user: user) }
      it "リダイレクトされること" do
        get "/rooms/#{room.id}/tournament"
        expect(response.status).to eq 302
      end
    end
    describe "#community_show" do
      let(:community) { create(:community, user: user) }
      let!(:room) { create(:room, :community_room, community: community, user: user) }
      let!(:community_room) { CommunityUser.create(community: community, user: user) }
      it "リダイレクトされること" do
        get "/rooms/#{room.id}/community"
        expect(response.status).to eq 302
      end
    end
    describe "#create_private_room" do
      it "新しい部屋が作成されないこと" do
        expect {
          post rooms_create_private_room_path, params: { user_id: user.id }
        }.not_to change(Room, :count)
        expect(response.status).to eq 302
      end
    end
    describe "#private_message" do
      it "リダイレクトされること" do
        get rooms_private_message_path
        expect(response.status).to eq 302
      end
    end
    describe "#participating_post" do
      it "リダイレクトされること" do
        get rooms_participating_post_path
        expect(response.status).to eq 302
      end
    end
    describe "#participating_tournament" do
      it "リダイレクトされること" do
        get rooms_participating_tournament_path
        expect(response.status).to eq 302
      end
    end
    describe "#participating_community" do
      it "リダイレクトされること" do
        get rooms_participating_community_path
        expect(response.status).to eq 302
      end
    end
  end
end
