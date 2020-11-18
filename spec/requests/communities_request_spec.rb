require 'rails_helper'

RSpec.describe "Communities", type: :request do
  context "ログインしている状態" do
    before do
      @user = create(:user)
      sign_in @user
    end
    describe "#new" do
      it "正常なレスポンスを返すこと" do
        get new_community_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#create" do
      context "有効な属性値の場合" do
        it "投稿を追加できること" do
          community_params = attributes_for(:community, :with_room)
          expect {
            post communities_path, params: { community: community_params }
          }.to change(@user.communities, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "投稿が追加できないこと" do
          community_params = attributes_for(:community, :invalid)
          expect {
            post communities_path, params: { community: community_params }
          }.not_to change(@user.communities, :count)
        end
      end
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get communities_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#show" do
      it "正常なレスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        get community_path(community)
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#edit" do
      it " 正常なレスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        get edit_community_path(community)
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#update" do
      context "有効な属性値の場合" do
        it "正常に更新されること" do
          community = create(:community, :with_room, user: @user)
          community_params = attributes_for(:community, :with_room_update)
          patch community_path(community), params: { community: community_params }
          expect(community.reload.community_place).to eq "静岡県"
        end
      end
      context "無効な属性値の場合" do
        it "更新ができないこと" do
          community = create(:community, :with_room, user: @user)
          community_params = attributes_for(:community, :invalid)
          patch community_path(community), params: { community: community_params }
          expect(community.reload.community_place).to eq "東京都"
        end
      end
    end
    describe "#destroy" do
      it "正常に削除できること" do
        community = create(:community, :with_room, user: @user)
        expect { delete community_path(community) }.to change(@user.communities, :count).by(-1)
      end
    end
    describe "#communities_search_community" do
      context "有効な属性値の場合" do
        it "正常にレスポンスを返すこと" do
          community = create(:community, :with_room, user: @user)
          get communities_search_community_path, params: {"q"=>{"community_place_or_community_all_tag_or_room_room_name_cont"=>"東京", "community_date_start"=>"2022-01-01", "community_date_end"=>"2023-01-01"}}
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
      context "無効な属性値の場合" do
        it "302レスポンシブを返すこと" do
          community = create(:community, :with_room, user: @user)
          get communities_search_community_path, params: {"q"=>{"community_place_or_community_all_tag_or_room_room_name_cont"=>"東京", "community_date_start"=>"", "community_date_end"=>"2023-01-01"}}
          expect(response.status).to eq 302
          expect(response).to redirect_to communities_path
        end
      end
    end
    describe "#communities_community_participation" do
      it "大会に参加できること" do
        community = create(:community, :with_room, user: @user)
        expect {
          post communities_community_participation_path, params: { community: community.id }
        }.to change(@user.community_users, :count).by(1)
      end
    end
    describe "#communities_community_exit" do
      it "大会から退出することができる" do
        community = create(:community, :with_room, user: @user)
        CommunityUser.create(community: community, user: @user)
        expect {
          post communities_community_exit_path, params: { community: community.id }
        }.to change(@user.community_users, :count).by(-1)
      end
    end
  end
  context "ログインしていない状態" do
    before do
      @user = create(:user)
    end
    describe "#new" do
      it "302レスポンスを返すこと" do
        get new_community_path
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#create" do
      it "302レスポンスを返すこと" do
        community_params = attributes_for(:community, :with_room)
        expect {
          post communities_path, params: { community: community_params }
        }.not_to change(@user.communities, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get communities_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#show" do
      it "302レスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        get community_path(community)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#edit" do
      it " 302レスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        get edit_community_path(community)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#update" do
      it "302レスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        community_params = attributes_for(:community, :with_room_update)
        patch community_path(community), params: { community: community_params }
        expect(community.reload.community_place).not_to eq "静岡県"
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#destroy" do
      it "302レスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        expect { delete community_path(community) }.not_to change(@user.communities, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#communities_search_community" do
      it "正常にレスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        get communities_search_community_path, params: {"q"=>{"community_place_or_community_all_tag_or_room_room_name_cont"=>"東京", "community_date_start"=>"2022-01-01", "community_date_end"=>"2023-01-01"}}
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#communities_community_participation" do
      it "302レスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        expect {
          post communities_community_participation_path, params: { community: community.id }
        }.not_to change(@user.community_users, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#communities_community_exit" do
      it "302レスポンスを返すこと" do
        community = create(:community, :with_room, user: @user)
        CommunityUser.create(community: community, user: @user)
        expect {
          post communities_community_exit_path, params: { community: community.id }
        }.not_to change(@user.community_users, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  context "投稿者とログインユーザーが違う場合" do
    before do
      @community = create(:community, :with_room)
      @user = create(:user)
      sign_in @user
    end
    describe "#edit" do
      it "302レスポンスを返すこと" do
        get edit_community_path(@community)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#update" do
      it "302レスポンスを返すこと" do
        get edit_community_path(@community)
        community_params = attributes_for(:community, :with_room_update)
        patch community_path(@community), params: { community: community_params }
        expect(@community.reload.community_place).not_to eq "静岡県"
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#destroy" do
      it "302レスポンスを返すこと" do
        expect { delete community_path(@community) }.not_to change(Community, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
  end
end
