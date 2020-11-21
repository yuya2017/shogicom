require 'rails_helper'

RSpec.describe "Tops", type: :request do
  let(:user) { create(:user) }
  
  context "ログインしている状態" do
    before do
      sign_in user
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get root_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#mypage" do
      it "リクエストが成功すること" do
        get "/tops/#{user.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
  end
  context "ログインしていない状態" do
    before do
      user
    end
    describe "#index" do
      it "リクエストが成功すること" do
        get root_path
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
    describe "#mypage" do
      it "リクエストが成功すること" do
        get "/tops/#{user.id}"
        aggregate_failures do
          expect(response).to be_successful
          expect(response.status).to eq 200
        end
      end
    end
  end
end
