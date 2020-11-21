require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room, private_id: user.id, user: user) }
  let(:message_params) { attributes_for(:message) }
  let(:invalid_message_params) { attributes_for(:message, :invalid) }

  describe "#create" do
    before do
      sign_in user
      RSpec.configuration.session[:room_id] = room.id
    end
    context "有効な属性値の場合" do
      it "メッセージを追加できること" do
        expect {
          post messages_path, params: { message: message_params }
        }.to change(user.messages, :count).by(1)
      end
    end
    context "無効な属性値の場合" do
      it "メッセージを追加できないこと" do
        expect {
          post messages_path, params: { message: invalid_message_params }
        }.to change(user.messages, :count).by(0)
      end
    end
  end
end
