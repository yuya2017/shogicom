require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:create_post) { create(:post, :with_room, user: user) }
  let(:post_params) { attributes_for(:post, :with_room) }
  let(:invalid_post_params) { attributes_for(:post, :invalid) }
  let(:update_post_params) { attributes_for(:post, :with_update) }
  
  context "ログインしている状態" do
    before do
      sign_in user
    end
    describe "#new" do
      it "リクエストが成功すること" do
        get new_post_path
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
            post posts_path, params: { post: post_params }
          }.to change(user.posts, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "作成されないこと" do
          aggregate_failures do
            expect {
              post posts_path, params: { post: invalid_post_params }
            }.not_to change(user.posts, :count)
            expect(response.body).to include "は保存されませんでした"
          end
        end
      end
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get posts_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#show" do
      it "リクエストが成功すること" do
        get post_path(create_post)
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#edit" do
      it " リクエストが成功すること" do
        get edit_post_path(create_post)
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#update" do
      context "有効な属性値の場合" do
        it "正常に更新されること" do
          patch post_path(create_post), params: { post: update_post_params }
          expect(create_post.reload.post_chess).to eq "1級"
        end
      end
      context "無効な属性値の場合" do
        it "更新ができないこと" do
          patch post_path(create_post), params: { post: invalid_post_params }
          aggregate_failures do
            expect(create_post.reload.post_chess).to eq "30級"
            expect(response.body).to include "は保存されませんでした"
          end
        end
      end
    end
    describe "#destroy" do
      it "正常に削除できること" do
        post_id = create_post.id
        expect { delete post_path(create_post) }.to change(user.posts, :count).by(-1)
      end
    end
    describe "#posts_search_post" do
      it "リクエストが成功すること" do
        post_id = create_post.id
        get posts_search_post_path, params: {"q"=>{"post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont"=>"将棋ウォーズ"}}
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
  end
  context "ログインしていないとき" do
    before do
      user
    end
    describe "#new" do
      it "リダイレクトされること" do
        get new_post_path
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#create" do
      it "作成されないこと" do
        expect {
          post posts_path, params: { post: post_params }
        }.not_to change(user.posts, :count)
      end
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get posts_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#show" do
      it "リダイレクトされること" do
        get post_path(create_post)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe "#edit" do
      it " リダイレクトされること" do
        get edit_post_path(create_post)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#update" do
      it " 更新されないこと" do
        patch post_path(create_post), params: { post: update_post_params }
        aggregate_failures do
          expect(create_post.reload.post_chess).to eq "30級"
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#destroy" do
      it "削除されないこと" do
        create_post
        aggregate_failures do
          expect { delete post_path(create_post) }.not_to change(user.posts, :count)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
    describe "#posts_search_post" do
      it "リクエストが成功すること" do
        create_post
        get posts_search_post_path, params: {"q"=>{"post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont"=>"将棋ウォーズ"}}
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
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
        get edit_post_path(create_post)
        aggregate_failures do
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#update" do
      it "更新されないこと" do
        patch post_path(create_post), params: { post: post_params }
        aggregate_failures do
          expect(create_post.reload.post_chess).to eq "30級"
          expect(response).to redirect_to root_path
        end
      end
    end
    describe "#destroy" do
      it "削除されないこと" do
        create_post
        aggregate_failures do
          expect { delete post_path(create_post) }.not_to change(Post, :count)
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
