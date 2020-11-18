require 'rails_helper'

RSpec.describe "Tournaments", type: :request do
  context "ログインしている状態" do
    before do
      @user = create(:user)
      sign_in @user
    end
    describe "#new" do
      it "正常なレスポンスを返すこと" do
        get new_tournament_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#create" do
      context "有効な属性値の場合" do
        it "投稿を追加できること" do
          tournament_params = attributes_for(:tournament, :with_room)
          expect {
            post tournaments_path, params: { tournament: tournament_params }
          }.to change(@user.tournaments, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "投稿が追加できないこと" do
          tournament_params = attributes_for(:tournament, :invalid)
          expect {
            post tournaments_path, params: { tournament: tournament_params }
          }.not_to change(@user.tournaments, :count)
        end
      end
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get tournaments_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#show" do
      it "正常なレスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        get tournament_path(tournament)
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#edit" do
      it " 正常なレスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        get edit_tournament_path(tournament)
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#update" do
      context "有効な属性値の場合" do
        it "正常に更新されること" do
          tournament = create(:tournament, :with_room, user: @user)
          tournament_params = attributes_for(:tournament, :with_room_update)
          patch tournament_path(tournament), params: { tournament: tournament_params }
          expect(tournament.reload.tournament_chess).to eq "1級"
        end
      end
      context "無効な属性値の場合" do
        it "更新ができないこと" do
          tournament = create(:tournament, :with_room, user: @user)
          tournament_params = attributes_for(:tournament, :invalid)
          patch tournament_path(tournament), params: { tournament: tournament_params }
          expect(tournament.reload.tournament_chess).to eq "30級"
        end
      end
    end
    describe "#destroy" do
      it "正常に削除できること" do
        tournament = create(:tournament, :with_room, user: @user)
        expect { delete tournament_path(tournament) }.to change(@user.tournaments, :count).by(-1)
      end
    end
    describe "#tournaments_search_tournament" do
      context "有効な属性値の場合" do
        it "正常にレスポンスを返すこと" do
          tournament = create(:tournament, :with_room, user: @user)
          get tournaments_search_tournament_path, params: {"q"=>{"tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont"=>"将棋ウォーズ", "tournament_date_start"=>"2022-01-01", "tournament_date_end"=>"2023-01-01"}}
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
      context "無効な属性値の場合" do
        it "302レスポンシブを返すこと" do
          tournament = create(:tournament, :with_room, user: @user)
          get tournaments_search_tournament_path, params: {"q"=>{"tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont"=>"将棋ウォーズ", "tournament_date_start"=>"", "tournament_date_end"=>"2023-01-01"}}
          expect(response.status).to eq 302
          expect(response).to redirect_to tournaments_path
        end
      end
    end
    describe "#tournaments_tournament_participation" do
      it "大会に参加できること" do
        tournament = create(:tournament, :with_room, user: @user)
        expect {
          post tournaments_tournament_participation_path, params: { tournament: tournament.id }
        }.to change(@user.tournament_users, :count).by(1)
      end
    end
    describe "#tournaments_tournament_exit" do
      it "大会から退出することができる" do
        tournament = create(:tournament, :with_room, user: @user)
        TournamentUser.create(tournament: tournament, user: @user)
        expect {
          post tournaments_tournament_exit_path, params: { tournament: tournament.id }
        }.to change(@user.tournament_users, :count).by(-1)
      end
    end
  end
  context "ログインしていない状態" do
    before do
      @user = create(:user)
    end
    describe "#new" do
      it "302レスポンスを返すこと" do
        get new_tournament_path
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#create" do
      it "302レスポンスを返すこと" do
        tournament_params = attributes_for(:tournament, :with_room)
        expect {
          post tournaments_path, params: { tournament: tournament_params }
        }.not_to change(@user.tournaments, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get tournaments_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#show" do
      it "302レスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        get tournament_path(tournament)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#edit" do
      it " 302レスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        get edit_tournament_path(tournament)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#update" do
      it "302レスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        tournament_params = attributes_for(:tournament, :with_room_update)
        patch tournament_path(tournament), params: { tournament: tournament_params }
        expect(tournament.reload.tournament_chess).not_to eq "1級"
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#destroy" do
      it "302レスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        expect { delete tournament_path(tournament) }.not_to change(@user.tournaments, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#tournaments_search_tournament" do
      it "正常にレスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        get tournaments_search_tournament_path, params: {"q"=>{"tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont"=>"将棋ウォーズ", "tournament_date_start"=>"2022-01-01", "tournament_date_end"=>"2023-01-01"}}
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#tournaments_tournament_participation" do
      it "302レスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        expect {
          post tournaments_tournament_participation_path, params: { tournament: tournament.id }
        }.not_to change(@user.tournament_users, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#tournaments_tournament_exit" do
      it "302レスポンスを返すこと" do
        tournament = create(:tournament, :with_room, user: @user)
        TournamentUser.create(tournament: tournament, user: @user)
        expect {
          post tournaments_tournament_exit_path, params: { tournament: tournament.id }
        }.not_to change(@user.tournament_users, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  context "投稿者とログインユーザーが違う場合" do
    before do
      @tournament = create(:tournament, :with_room)
      @user = create(:user)
      sign_in @user
    end
    describe "#edit" do
      it "302レスポンスを返すこと" do
        get edit_tournament_path(@tournament)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#update" do
      it "302レスポンスを返すこと" do
        get edit_tournament_path(@tournament)
        tournament_params = attributes_for(:tournament, :with_room_update)
        patch tournament_path(@tournament), params: { tournament: tournament_params }
        expect(@tournament.reload.tournament_chess).not_to eq "1級"
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#destroy" do
      it "302レスポンスを返すこと" do
        expect { delete tournament_path(@tournament) }.not_to change(Tournament, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
  end
end
