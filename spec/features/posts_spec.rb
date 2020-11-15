require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  scenario "ユーザーが新しい対戦募集を行う" do
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    find('.header_icon').click
    click_link "対戦"
      expect {
      fill_in "部屋名*", with: "オンライン対戦"
      click_button "投稿"
      expect(page).to have_content "オンライン対戦を作成しました。"
    }.to change(Post, :count).by(1)
  end

  scenario "ユーザーは編集を行う" do
    room = create(:room, :post_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "対戦相手を探す"
    find(".post-#{room.post.id}").click
    click_link "編集"
    fill_in "部屋名*", with: "編集後の投稿"
    click_button "編集"
    expect(page).to have_content "更新しました。"
    click_link "対戦相手を探す"
    expect(page).to have_selector 'h4', text: "編集後の投稿"
  end

  scenario "投稿者以外は編集ボタンが表示されない" do
    room = create(:room, :post_room)
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "対戦相手を探す"
    find(".post-#{room.post.id}").click
    expect(page).not_to have_selector 'a', text: "編集"
  end

  scenario "ユーザーは削除を行う" do
    room = create(:room, :post_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "対戦相手を探す"
    find(".post-#{room.post.id}").click
    click_link "編集"
    expect {
      click_link "削除"
      expect(page).to have_content "#{room.room_name}を削除しました。"
    }.to change(Post, :count).by(-1)
  end

  scenario "検索画面が表示される" do
    room = create(:room, :post_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "対戦相手を探す"
    fill_in "q[post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont]", with: "将棋ウォーズ,30級,10分,誰でも,オンライン対戦部屋"
    click_button "検索する"
    expect(page).to have_selector 'h4', text: "オンライン対戦部屋"
  end
end
