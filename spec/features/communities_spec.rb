require 'rails_helper'

RSpec.feature "Communities", type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:community) { create(:community, :with_room, user: user) }

  scenario "ユーザーが新しいイベント募集を行う" do
    sign_in user
    visit root_path
    expect {
      find('.header_icon').click
      click_link "イベント開催"
      fill_in "イベント名*", with: "大会"
      fill_in "開催場所*", with: "東京都"
      fill_in "参加費*", with: 0
      fill_in "応募人数",with: 3
      fill_in "応募期間*", with: Date.today >> 1
      fill_in "開催日時*", with: Date.today >> 2
      click_button "投稿"
    }.to change(user.communities, :count).by(1)
  end

  scenario "ユーザーは編集を行う" do
    community_id = community.id
    sign_in user
    visit root_path
    click_link "イベントを探す"
    find(".community-#{community_id}").click
    click_link  "編集"
    fill_in "イベント名*", with: "編集後の投稿"
    click_button "編集"
    expect(page).to have_content "更新しました。"
    click_link "イベントを探す"
    expect(page).to have_selector 'h4', text: "編集後の投稿"
  end

  scenario "投稿者以外は編集ボタンが表示されない" do
    community_id = community.id
    sign_in user2
    visit root_path
    click_link "イベントを探す"
    find(".community-#{community_id}").click
    expect(page).not_to have_selector 'a', text: "編集"
  end

  scenario "ユーザーは削除を行う" do
    community_id = community.id
    sign_in user
    visit root_path
    expect {
      click_link "イベントを探す"
      find(".community-#{community_id}").click
      click_link "編集"
      click_link "削除"
      expect(page).to have_content "を削除しました。"
    }.to change(Community, :count).by(-1)
  end

  scenario "検索画面が表示される" do
    community_id = community.id
    visit root_path
    sign_in user
    visit root_path
    click_link "イベントを探す"
    fill_in "q[community_place_or_community_all_tag_or_room_room_name_cont]", with: "東京,誰でも,イベント部屋"
    click_button "検索する"
    expect(page).to have_selector 'h4', text: "イベント部屋"
  end

  scenario "イベントに参加、退出ができること" do
    community_id = community.id
    user = create(:user)
    sign_in user
    visit root_path
    click_link "イベントを探す"
    find(".community-#{community_id}").click
    expect{ click_link "イベントに参加" }.to change(user.community_users, :count).by(1)
    expect(page).to have_content "イベントへ参加しました。"
    click_link "詳細"
    expect { click_link "退出" }.to change(user.community_users, :count).by(-1)
    expect(page).to have_content "イベントから抜けました。"
  end

  scenario "google_map", js:true do
    community_id = community.id
    sign_in user2
    visit root_path
    find(".top_community_search").click
    expect(page).to have_css "img[src='https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi2_hdpi.png']"
    find("area").click
    find(".marker-#{community_id}").click
    expect(page).to have_css "img[src='https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi2_hdpi.png']"
    expect{ click_link "イベントに参加" }.to change(user2.community_users, :count).by(1)
    expect(page).to have_content "イベントへ参加しました。"
    click_link "詳細"
    page.accept_confirm do
      click_on "退出"
    end
    expect(page).to have_content "イベントから抜けました。"
  end

end
