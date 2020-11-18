require 'rails_helper'

RSpec.describe "Posts", type: :request do
  context "ログインしている状態" do
    before do
      @user = create(:user)
      sign_in @user
    end
    describe "#new" do
      it "正常なレスポンスを返すこと" do
        get new_post_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#create" do
      context "有効な属性値の場合" do
        it "投稿を追加できること" do
          post_params = attributes_for(:post, :with_room)
          expect {
            post posts_path, params: { post: post_params }
          }.to change(@user.posts, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "投稿が追加できないこと" do
          post_params = attributes_for(:post, :invalid)
          expect {
            post posts_path, params: { post: post_params }
          }.not_to change(@user.posts, :count)
        end
      end
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get posts_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#show" do
      it "正常なレスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        get post_path(post)
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#edit" do
      it " 正常なレスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        get edit_post_path(post)
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#update" do
      context "有効な属性値の場合" do
        it "正常に更新されること" do
          post = create(:post, :with_room, user: @user)
          post_params = attributes_for(:post, :with_room_update)
          patch post_path(post), params: { post: post_params }
          expect(post.reload.post_chess).to eq "1級"
        end
      end
      context "無効な属性値の場合" do
        it "更新ができないこと" do
          post = create(:post, :with_room, user: @user)
          post_params = attributes_for(:post, :invalid)
          patch post_path(post), params: { post: post_params }
          expect(post.reload.post_chess).to eq "30級"
        end
      end
    end
    describe "#destroy" do
      it "正常に削除できること" do
        post = create(:post, :with_room, user: @user)
        expect { delete post_path(post) }.to change(@user.posts, :count).by(-1)
      end
    end
    describe "#posts_search_post" do
      it "正常にレスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        get posts_search_post_path, params: {"q"=>{"post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont"=>"将棋ウォーズ"}}
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
  end
  context "ログインしていない状態" do
    before do
      @user = create(:user)
    end
    describe "#new" do
      it "302レスポンスを返すこと" do
        get new_post_path
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#create" do
      it "302レスポンスを返すこと" do
        post_params = attributes_for(:post, :with_room)
        expect {
          post posts_path, params: { post: post_params }
        }.not_to change(@user.posts, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get posts_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#show" do
      it "302レスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        get post_path(post)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#edit" do
      it " 302レスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        get edit_post_path(post)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#update" do
      it "302レスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        post_params = attributes_for(:post, :with_room_update)
        patch post_path(post), params: { post: post_params }
        expect(post.reload.post_chess).not_to eq "1級"
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#destroy" do
      it "302レスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        expect { delete post_path(post) }.not_to change(@user.posts, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#posts_search_post" do
      it "正常にレスポンスを返すこと" do
        post = create(:post, :with_room, user: @user)
        get posts_search_post_path, params: {"q"=>{"post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont"=>"将棋ウォーズ"}}
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
  end
  context "投稿者とログインユーザーが違う場合" do
    before do
      @post = create(:post, :with_room)
      @user = create(:user)
      sign_in @user
    end
    describe "#edit" do
      it "302レスポンスを返すこと" do
        get edit_post_path(@post)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#update" do
      it "302レスポンスを返すこと" do
        get edit_post_path(@post)
        post_params = attributes_for(:post, :with_room_update)
        patch post_path(@post), params: { post: post_params }
        expect(@post.reload.post_chess).not_to eq "1級"
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
    describe "#destroy" do
      it "302レスポンスを返すこと" do
        expect { delete post_path(@post) }.not_to change(Post, :count)
        expect(response.status).to eq 302
        expect(response).to redirect_to root_path
      end
    end
  end
end
