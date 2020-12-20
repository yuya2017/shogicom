require 'rails_helper'

RSpec.describe "Communities", type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:community) { create(:community, :with_room, user: user) }
  let(:community_params) { attributes_for(:community, :with_room) }
  let(:invalid_community_params) { attributes_for(:community, :invalid) }
  let(:update_community_params) { attributes_for(:community, :with_update) }

  context "ログインしている状態" do
    before do
      sign_in user
    end
    describe "#new" do
      it "リクエストが成功すること" do
        get new_community_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#create" do
      context "有効な属性値の場合" do
        it "作成できること" do
          expect {
            post communities_path, params: { community: community_params }
          }.to change(user.communities, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "作成できないこと" do
          aggregate_failures do
            expect {
              post communities_path, params: { community: invalid_community_params }
            }.not_to change(user.communities, :count)
            expect(response.body).to include "は保存されませんでした"
          end
        end
      end
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get communities_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#show" do
      it "リクエストが成功すること" do
        get community_path(community)
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#edit" do
      it " リクエストが成功すること" do
        get edit_community_path(community)
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#update" do
      context "有効な属性値の場合" do
        it "正常に更新されること" do
          patch community_path(community), params: { community: update_community_params }
          expect(community.reload.community_place).to eq "静岡県"
        end
      end
      context "無効な属性値の場合" do
        it "更新ができないこと" do
          patch community_path(community), params: { community: invalid_community_params }
          aggregate_failures do
            expect(community.reload.community_place).to eq "東京都"
            expect(response.body).to include "は保存されませんでした"
          end
        end
      end
    end
    describe "#destroy" do
      it "正常に削除できること" do
        community
        expect { delete community_path(community) }.to change(user.communities, :count).by(-1)
      end
    end
    describe "#communities_search_community" do
      context "有効な属性値の場合" do
        it "リクエストが成功すること" do
          community
          get communities_search_community_path, params: {"q"=>{"community_place_or_community_all_tag_or_room_room_name_cont"=>"東京", "community_date_start"=>"2022-01-01", "community_date_end"=>"2023-01-01"}}
          aggregate_failures do
            expect(response).to be_successful
            expect(response.status).to eq 200
          end
        end
      end
      context "無効な属性値の場合" do
        it "リダイレクトされること" do
          community
          get communities_search_community_path, params: {"q"=>{"community_place_or_community_all_tag_or_room_room_name_cont"=>"東京", "community_date_start"=>"", "community_date_end"=>"2023-01-01"}}
          aggregate_failures do
            expect(response.status).to eq 302
            expect(response).to redirect_to communities_path
          end
        end
      end
    end
    describe "#communities_community_participation" do
      it "大会に参加できること" do
        expect {
          post communities_community_participation_path, params: { community: community.id }
        }.to change(user.community_users, :count).by(1)
      end
    end
    describe "#communities_community_exit" do
      it "大会から退出することができる" do
        CommunityUser.create(community: community, user: user)
        expect {
          post communities_community_exit_path, params: { community: community.id }
        }.to change(user.community_users, :count).by(-1)
      end
    end
  end
  context "ログインしていない状態" do
    before do
      create(:user)
    end
    describe "#new" do
      it "リダイレクトされること" do
        get new_community_path
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#create" do
      it "作成できないこと" do
        aggregate_failures do
          expect {
            post communities_path, params: { community: community_params }
          }.not_to change(user.communities, :count)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get communities_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#show" do
      it "リダイレクトされること" do
        get community_path(community)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#edit" do
      it " リダイレクトされること" do
        get edit_community_path(community)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#update" do
      it "更新できないこと" do
        patch community_path(community), params: { community: update_community_params }
        aggregate_failures do
          expect(community.reload.community_place).to eq "東京都"
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#destroy" do
      it "削除できないこと" do
        community
        aggregate_failures do
          expect { delete community_path(community) }.not_to change(user.communities, :count)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#communities_search_community" do
      it "正常にレスポンスを返すこと" do
        community
        get communities_search_community_path, params: {"q"=>{"community_place_or_community_all_tag_or_room_room_name_cont"=>"東京", "community_date_start"=>"2022-01-01", "community_date_end"=>"2023-01-01"}}
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#communities_community_participation" do
      it "リダイレクトされること" do
        aggregate_failures do
          expect {
            post communities_community_participation_path, params: { community: community.id }
          }.not_to change(user.community_users, :count)
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#communities_community_exit" do
      it "リダイレクトされること" do
        CommunityUser.create(community: community, user: user)
        aggregate_failures do
          expect {
            post communities_community_exit_path, params: { community: community.id }
          }.not_to change(user.community_users, :count)
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
        get edit_community_path(community)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#update" do
      it "更新できないこと" do
        patch community_path(community), params: { community: community_params }
        aggregate_failures do
          expect(community.reload.community_place).to eq "東京都"
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#destroy" do
      it "削除できないこと" do
        aggregate_failures do
          community
          expect { delete community_path(community) }.not_to change(Community, :count)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
