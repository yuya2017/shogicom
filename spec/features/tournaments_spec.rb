require 'rails_helper'

RSpec.feature "Tournaments", type: :feature do
  scenario "ユーザーが新しい大会募集を行う" do
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    expect {
      find('.header_icon').click
      click_link "大会開催"
      fill_in "大会名*", with: "大会"
      fill_in "応募人数",with: 3
      fill_in "応募期間*", with: "2022/02/22"
      fill_in "tournament_tournament_at_date", with: "2022/02/25"
      select "12", from: "tournament_tournament_at_hour"
      select "30", from: "tournament_tournament_at_minute"
      click_button "投稿"
    }.to change(Tournament, :count).by(1)
  end

  scenario "ユーザーは編集を行う" do
    room = create(:room, :tournament_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "大会を探す"
    find(".tournament-#{room.tournament.id}").click
    click_link  "編集"
    fill_in "大会名*", with: "編集後の投稿"
    click_button "編集"
    expect(page).to have_content "更新しました。"
    click_link "大会を探す"
    expect(page).to have_selector 'h4', text: "編集後の投稿"
  end

  scenario "投稿者以外は編集ボタンが表示されない" do
    room = create(:room, :tournament_room)
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "大会を探す"
    find(".tournament-#{room.tournament.id}").click
    expect(page).not_to have_selector 'a', text: "編集"
  end

  scenario "ユーザーは削除を行う" do
    room = create(:room, :tournament_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    expect {
      click_link "大会を探す"
      find(".tournament-#{room.tournament.id}").click
      click_link "編集"
      click_link "削除"
      expect(page).to have_content "大会部屋を削除しました。"
    }.to change(Tournament, :count).by(-1)
  end

  scenario "検索画面が表示される"  do
    room = create(:room, :tournament_room)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: room.user.email
    fill_in "パスワード*", with: room.user.password
    click_button "ログイン"
    click_link "大会を探す"
    fill_in "q[tournament_date_start]", with: "2022/01/01"
    fill_in "q[tournament_date_end]", with: "2023/01/01"
    fill_in "q[tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont]", with: "将棋,10分,誰でも,大会部屋,30級"
    click_button "検索する"
    expect(page).to have_selector 'h4', text: "大会部屋"
  end

  scenario "大会に参加、退出ができること"  do
    room = create(:room, :tournament_room)
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: user.email
    fill_in "パスワード*", with: user.password
    click_button "ログイン"
    click_link "大会を探す"
    find(".tournament-#{room.tournament.id}").click
    expect{ click_link "大会に参加" }.to change(TournamentUser, :count).by(1)
    expect(page).to have_content "大会へ参加しました。"
    click_link "詳細"
    expect { click_link "退出" }.to change(TournamentUser, :count).by(-1)
    expect(page).to have_content "大会から抜けました。"
  end
end
