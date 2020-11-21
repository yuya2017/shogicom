require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, :invalid) }
  let(:update_user_params) { attributes_for(:user, :update) }
  let(:update_user_email_params) { attributes_for(:user, :update_email) }

  describe "new" do
    it "リクエストが成功すること" do
      get new_user_registration_path
      aggregate_failures do
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
  end
  describe "#create" do
    before do
      ActionMailer::Base.deliveries.clear
    end
    context "有効な属性値の場合" do
      it "認証メールが送信されること" do
        post user_registration_path, params: { user: user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
      it "作成されること" do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end
    end
    context "無効な属性値の場合" do
      it "認証メールが送信されないこと" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end
      it "作成されないこと" do
        aggregate_failures do
          expect {
            post user_registration_path, params: { user: invalid_user_params }
          }.to_not change(User, :count)
          expect(response.body).to include "は保存されませんでした"
        end
      end
    end
  end

  describe "#edit" do
    context "ログインしている場合" do
      before do
        sign_in user
      end
      it "リクエストが成功すること" do
        get edit_user_registration_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    context "ログインしていない場合" do
      it "リダイレクトされること" do
        get edit_user_registration_path
        aggregate_failures do
          expect(response.status).to eq 302
          is_expected.to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "#update" do
    context "ログインしている場合" do
      before do
        sign_in user
      end
      context "email以外の変更の場合" do
        context "有効な属性値の場合" do
          it "正常に更新されること" do
            patch user_registration_path, params: { user: update_user_params }
            expect(user.reload.user_chess).to eq "1級"
          end
        end
        context "無効な属性値の場合" do
          it "更新されないこと" do
            patch user_registration_path, params: { user: invalid_user_params }
            aggregate_failures do
              expect(user.reload.user_chess).to eq "30級"
              expect(response.body).to include "は保存されませんでした"
            end
          end
        end
      end
      context "emailの変更の場合" do
        it "認証メールが送信されること" do
          ActionMailer::Base.deliveries.clear
          patch user_registration_path, params: { user: update_user_email_params }
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end
      end
    end
    context "ログインしていない状態" do
      before do
        user_id = user.id
      end
      context "email以外の変更の場合" do
        it "更新されないこと" do
          patch user_registration_path, params: { user: update_user_params }
          expect(response).to redirect_to new_user_session_path
        end
      end
      context "emailの変更の場合" do
        it "更新されないこと" do
          patch user_registration_path, params: { user: update_user_params }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "#destroy" do
    context "ログインしている場合" do
      before do
        sign_in user
      end
      it "正常に削除されること" do
        aggregate_failures do
          expect { delete user_registration_path }.to change(User, :count).by(-1)
          expect(response).to redirect_to root_path
        end
      end
    end
    context "ログインしていない場合" do
      it "削除されないこと" do
        user_id = user.id
        aggregate_failures do
          expect { delete user_registration_path }.not_to change(User, :count)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
