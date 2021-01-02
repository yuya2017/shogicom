require 'rails_helper'

RSpec.describe "Messages", type: :system do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:room) { create(:room, user: user, private_id: user2.id) }
  it "メッセージが生成されること", js:true do
    RSpec.configuration.session[:room_id] = room.id
    sign_in user
    visit root_path
    click_link "ユーザーアイコン"
    click_link "チャットルーム"
    click_link "#{user2.user_name}"
    expect {
      fill_in "message_content", with: "宜しくお願いします。"
      click_button "送信"
      sleep 5
    }.to change(Message, :count).by(1)
  end
end
