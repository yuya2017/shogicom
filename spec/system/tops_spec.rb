require 'rails_helper'

RSpec.describe "Tops", type: :system do
  it "myページの投稿一覧に自分が投稿したものが表示される" do
    user = create(:user)
    user2 = create(:user)
    post = create(:post, :with_room, user: user)
    tournament = create(:tournament, :with_room, user: user)
    community = create(:community, :with_room, user: user)
    sign_in user
    visit root_path
    click_link "ユーザーアイコン"
    expect(page).to have_selector 'h4', text: "#{post.room.room_name}"
    expect(page).to have_selector 'h4', text: "#{tournament.room.room_name}"
    expect(page).to have_selector 'h4', text: "#{community.room.room_name}"
    click_link "ログアウト"
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user2.email
    fill_in "パスワード*", with: user2.password
    click_button "ログイン"
    click_link "ユーザーアイコン"
    expect(page).not_to have_selector 'h4', text: "#{post.room.room_name}"
    expect(page).not_to have_selector 'h4', text: "#{tournament.room.room_name}"
    expect(page).not_to have_selector 'h4', text: "#{community.room.room_name}"
  end
end
