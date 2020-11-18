require 'rails_helper'

RSpec.describe "Tops", type: :request do
  context "ログイン状態" do
    before do
      @user = create(:user)
      sign_in @user
    end
    describe "#index" do
      it "正常なレスポンスを返すこと" do
        get root_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#mypage" do
      it "tops/mypageが正常なレスポンスを返すこと" do
        get "/tops/#{@user.id}"
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
  end
  context "ログインしていない状態" do
    before do
      @user = create(:user)
    end
    describe "#index" do
      it "tops/indexが正常なレスポンスを返すこと" do
        get root_path
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
    describe "#mypage" do
      it "tops/mypageが正常なレスポンスを返すこと" do
        get "/tops/#{@user.id}"
        expect(response).to be_successful
        expect(response.status).to eq 200
      end
    end
  end
end
