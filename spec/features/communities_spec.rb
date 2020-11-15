require 'rails_helper'

RSpec.feature "Communities", type: :feature do
  scenario "ユーザーが新しいイベント募集を行う" do
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    expect {
      find('.header_icon').click
      click_link "イベント開催"
      fill_in "イベント名*", with: "大会"
      fill_in "開催場所*", with: "東京都"
      fill_in "参加費*", with: 0
      fill_in "応募人数",with: 3
      fill_in "応募期間*", with: "2022/02/22"
      fill_in "開催日時*", with: "2022/02/25"
      click_button "投稿"
    }.to change(Community, :count).by(1)
  end

  scenario "ユーザーは編集を行う" do
    room = create(:room, :community_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "イベントを探す"
    find(".community-#{room.community.id}").click
    click_link  "編集"
    fill_in "イベント名*", with: "編集後の投稿"
    click_button "編集"
    expect(page).to have_content "更新しました。"
    click_link "イベントを探す"
    expect(page).to have_selector 'h4', text: "編集後の投稿"
  end

  scenario "投稿者以外は編集ボタンが表示されない" do
    room = create(:room, :community_room)
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "イベントを探す"
    find(".community-#{room.community.id}").click
    expect(page).not_to have_selector 'a', text: "編集"
  end

  scenario "ユーザーは削除を行う" do
    room = create(:room, :community_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    expect {
      click_link "イベントを探す"
      find(".community-#{room.community.id}").click
      click_link "編集"
      click_link "削除"
      expect(page).to have_content "を削除しました。"
    }.to change(Community, :count).by(-1)
  end

  scenario "検索画面が表示される"  do
    room = create(:room, :community_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "イベントを探す"
    fill_in "q[community_date_start]", with: "2022/01/01"
    fill_in "q[community_date_end]", with: "2023/01/01"
    fill_in "q[community_place_or_community_all_tag_or_room_room_name_cont]", with: "東京,誰でも,イベント部屋"
    click_button "検索する"
    expect(page).to have_selector 'h4', text: "イベント部屋"
  end

  scenario "イベントに参加、退出ができること"  do
    room = create(:room, :community_room)
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "イベントを探す"
    find(".community-#{room.community.id}").click
    expect{ click_link "イベントに参加" }.to change(CommunityUser, :count).by(1)
    expect(page).to have_content "イベントへ参加しました。"
    click_link "詳細"
    expect { click_link "退出" }.to change(CommunityUser, :count).by(-1)
    expect(page).to have_content "イベントから抜けました。"
  end

end
