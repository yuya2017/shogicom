require 'rails_helper'

RSpec.describe "Messages", type: :request do
  describe "#create" do
    context "有効な属性値の場合" do
      it "投稿を追加できること" do
        pending
        room = create(:room, :post_room)
        message_params = attributes_for(:message, room_id: room.id, user_id: room.post.user.id)
        puts message_params
        expect {
          post messages_path, params: { message: message_params }
        }.to change(room.post.user.messages, :count).by(1)
      end
    end
  end
end
