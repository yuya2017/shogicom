require 'rails_helper'

RSpec.describe "Tournaments", type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:tournament) { create(:tournament, :with_room, user: user) }
  let(:tournament_params) { attributes_for(:tournament, :with_room) }
  let(:invalid_tournament_params) { attributes_for(:tournament, :invalid) }
  let(:update_tournament_params) { attributes_for(:tournament, :with_update) }

  context "ログインしているとき" do
    before do
      sign_in user
    end
    describe "#new" do
      it "リクエストが成功すること" do
        get new_tournament_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#create" do
      context "有効な属性値の場合" do
        it "投稿を追加できること" do
          expect {
            post tournaments_path, params: { tournament: tournament_params }
          }.to change(user.tournaments, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "投稿が追加できないこと" do
          aggregate_failures do
            expect {
              post tournaments_path, params: { tournament: invalid_tournament_params }
            }.not_to change(user.tournaments, :count)
            expect(response.body).to include "は保存されませんでした"
          end
        end
      end
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get tournaments_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#show" do
      it "リクエストが成功すること" do
        get tournament_path(tournament)
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#edit" do
      it " リクエストが成功すること" do
        get edit_tournament_path(tournament)
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#update" do
      context "有効な属性値の場合" do
        it "正常に更新されること" do
          patch tournament_path(tournament), params: { tournament: update_tournament_params }
          expect(tournament.reload.tournament_chess).to eq "1級"
        end
      end
      context "無効な属性値の場合" do
        it "更新ができないこと" do
          patch tournament_path(tournament), params: { tournament: invalid_tournament_params }
          aggregate_failures do
            expect(tournament.reload.tournament_chess).to eq "30級"
            expect(response.body).to include "は保存されませんでした"
          end
        end
      end
    end
    describe "#destroy" do
      it "正常に削除できること" do
        tournament
        expect { delete tournament_path(tournament) }.to change(user.tournaments, :count).by(-1)
      end
    end
    describe "#tournaments_search_tournament" do
      context "有効な属性値の場合" do
        it "リクエストが成功すること" do
          tournament
          get tournaments_search_tournament_path, params: {"q"=>{"tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont"=>"将棋ウォーズ", "tournament_date_start"=>"2022-01-01", "tournament_date_end"=>"2023-01-01"}}
          aggregate_failures do
            expect(response).to be_successful
            expect(response.status).to eq 200
          end
        end
      end
      context "無効な属性値の場合" do
        it "リダイレクトされること" do
          tournament
          get tournaments_search_tournament_path, params: {"q"=>{"tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont"=>"将棋ウォーズ", "tournament_date_start"=>"", "tournament_date_end"=>"2023-01-01"}}
          aggregate_failures do
            expect(response.status).to eq 302
            expect(response).to redirect_to tournaments_path
          end
        end
      end
    end
    describe "#tournaments_tournament_participation" do
      it "大会に参加できること" do
        expect {
          post tournaments_tournament_participation_path, params: { tournament: tournament.id }
        }.to change(user.tournament_users, :count).by(1)
      end
    end
    describe "#tournaments_tournament_exit" do
      it "大会から退出することができる" do
        TournamentUser.create(tournament: tournament, user: user)
        expect {
          post tournaments_tournament_exit_path, params: { tournament: tournament.id }
        }.to change(user.tournament_users, :count).by(-1)
      end
    end
  end
  context "ログインしていないとき" do
    before do
      user
    end
    describe "#new" do
      it "リダイレクトされること" do
        get new_tournament_path
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#create" do
      it "リダイレクトされること" do
        aggregate_failures do
          expect {
            post tournaments_path, params: { tournament: tournament_params }
          }.not_to change(user.tournaments, :count)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get tournaments_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#show" do
      it "リダイレクトされること" do
        get tournament_path(tournament)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#edit" do
      it " リダイレクトされること" do
        get edit_tournament_path(tournament)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#update" do
      it "更新できないこと" do
        patch tournament_path(tournament), params: { tournament: update_tournament_params }
        aggregate_failures do
          expect(tournament.reload.tournament_chess).to eq "30級"
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#destroy" do
      it "削除できないこと" do
        tournament
        aggregate_failures do
          expect { delete tournament_path(tournament) }.not_to change(user.tournaments, :count)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#tournaments_search_tournament" do
      it "正常にレスポンスを返すこと" do
        tournament
        get tournaments_search_tournament_path, params: {"q"=>{"tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont"=>"将棋ウォーズ", "tournament_date_start"=>"2022-01-01", "tournament_date_end"=>"2023-01-01"}}
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#tournaments_tournament_participation" do
      it "リダイレクトされること" do
        aggregate_failures do
          expect {
            post tournaments_tournament_participation_path, params: { tournament: tournament.id }
          }.not_to change(user.tournament_users, :count)
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#tournaments_tournament_exit" do
      it "リダイレクトされること" do
        TournamentUser.create(tournament: tournament, user: user)
        aggregate_failures do
          expect {
            post tournaments_tournament_exit_path, params: { tournament: tournament.id }
          }.not_to change(user.tournament_users, :count)
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
  context "投稿者とログインユーザーが違う場合" do
    before do
      sign_in user2
    end
    describe "#edit" do
      it "リダイレクトされること" do
        get edit_tournament_path(tournament)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#update" do
      it "更新できないこと" do
        get edit_tournament_path(tournament)
        patch tournament_path(tournament), params: { tournament: update_tournament_params }
        aggregate_failures do
          expect(tournament.reload.tournament_chess).to eq "30級"
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#destroy" do
      it "削除できないこと" do
        tournament
        aggregate_failures do
          expect { delete tournament_path(tournament) }.not_to change(Tournament, :count)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
