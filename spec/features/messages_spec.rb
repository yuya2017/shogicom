require 'rails_helper'

RSpec.feature "Messages", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  scenario "メッセージが生成されること", js:true do
    create(:room, user: user, private_id: user2.id)
    sign_in user
    visit root_path
    click_link "ユーザーアイコン"
    click_link "チャットルーム"
    click_link "#{user2.user_name}"
    fill_in "message_content", with: "宜しくお願いします。"
    click_button "送信"
    expect(page).to have_selector 'p', text: "宜しくお願いします。"
  end
end
