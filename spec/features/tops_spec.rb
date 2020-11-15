require 'rails_helper'

RSpec.feature "Tops", type: :feature do
  scenario "myページの投稿一覧に自分が投稿したものが表示される" do
    user = create(:user)
    user2 = create(:user)
    post = create(:post, user: user)
    tournament = create(:tournament, user: user)
    community = create(:community, user: user)
    post_room = create(:room, :post_room, post: post)
    tournament_room = create(:room, :tournament_room, tournament: tournament)
    community_room = create(:room, :community_room, community: community)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "ユーザーアイコン"
    expect(page).to have_selector 'h4', text: "#{post_room.room_name}"
    expect(page).to have_selector 'h4', text: "#{tournament_room.room_name}"
    expect(page).to have_selector 'h4', text: "#{community_room.room_name}"
    click_link "ログアウト"
    click_link "ログイン"
    puts user2.email
    puts user2.password
    fill_in "Eメールアドレス*", with: user2.email
    fill_in "パスワード*", with: user2.password
    click_button "ログイン"
    click_link "ユーザーアイコン"
    expect(page).not_to have_selector 'h4', text: "#{post_room.room_name}"
    expect(page).not_to have_selector 'h4', text: "#{tournament_room.room_name}"
    expect(page).not_to have_selector 'h4', text: "#{community_room.room_name}"
  end
end
