require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "ユーザー登録" do
    visit root_path
    click_link "新規登録"
    expect(page).to have_css "img[src*='assets/profile.jpg']"
    expect {
      fill_in "名前*", with: "鈴木太郎"
      fill_in "Eメールアドレス*", with: "tester@example.com"
      fill_in "棋力*", with: "30級"
      fill_in "よく使用するアプリ*", with: "将棋ウォーズ"
      fill_in "よく行う持ち時間*", with: "10分"
      select "東京都", from: "user[user_pref]"
      fill_in "自己紹介", with: "宜しくお願いいたします。"
      fill_in "パスワード", with: "password"
      fill_in "パスワード確認用*", with: "password"
      attach_file 'user[user_image]', "#{Rails.root}/spec/factories/profile_sample.jpg"
      expect { click_button '登録' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    }.to change(User, :count).by(1)
    mail = ActionMailer::Base.deliveries.last
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
    expect(page).to have_content 'メールアドレスが確認できました。'
    fill_in "メールアドレス*", with: "tester@example.com"
    fill_in "パスワード*", with: "password"
    click_button "ログイン"
    expect(page).to have_content "ログインしました"
    click_link "ユーザーアイコン"
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました"
  end

  scenario "ユーザー編集" do
    user = create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス*", with: "#{user.email}"
    fill_in "パスワード*", with: "#{user.password}"
    click_button "ログイン"
    click_link "ユーザーアイコン"
    click_link "アカウント編集"
    fill_in "名前*", with: "鈴木二郎"
    click_button "変更"
    expect(page).to have_content "アカウント情報を変更しました。"
    click_link "ユーザーアイコン"
    expect(page).to have_selector 'h4', text: "鈴木二郎"
  end

  scenario "パスワード変更" do
    user = create(:user)
    visit root_path
    click_link "ログイン"
    click_link "パスワードをお忘れですか？"
    fill_in "Eメールアドレス*", with: "#{user.email}"
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    mail = ActionMailer::Base.deliveries.last
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
    fill_in "新しいパスワード", with: "newpassword"
    fill_in "パスワード確認用", with: "newpassword"
    click_button "変更"
    expect(page).to have_content "パスワードが正しく変更されました。"
    click_link "ユーザーアイコン"
    click_link "ログアウト"
    click_link "ログイン"
    fill_in "Eメールアドレス*", with: "#{user.email}"
    fill_in "パスワード*", with: "newpassword"
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
    click_link "ユーザーアイコン"
    click_link "パスワード変更"
    fill_in "Eメールアドレス*", with: "#{user.email}"
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    mail = ActionMailer::Base.deliveries.last
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
    fill_in "新しいパスワード", with: "newpassword"
    fill_in "パスワード確認用", with: "newpassword"
    click_button "変更"
    expect(page).to have_content "パスワードが正しく変更されました。"
  end

  scenario "確認メールの再送信" do
    visit root_path
    click_link "新規登録"
    expect(page).to have_css "img[src*='assets/profile.jpg']"
    expect {
      fill_in "名前*", with: "鈴木太郎"
      fill_in "Eメールアドレス*", with: "tester@example.com"
      fill_in "棋力*", with: "30級"
      fill_in "よく使用するアプリ*", with: "将棋ウォーズ"
      fill_in "よく行う持ち時間*", with: "10分"
      select "東京都", from: "user[user_pref]"
      fill_in "自己紹介", with: "宜しくお願いいたします。"
      fill_in "パスワード", with: "password"
      fill_in "パスワード確認用*", with: "password"
      attach_file 'user[user_image]', "#{Rails.root}/spec/factories/profile_sample.jpg"
      click_button "登録"
      click_link "ログイン"
      click_link "確認メールの再送信"
      fill_in "Eメールアドレス*", with: "tester@example.com"
      expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    }.to change(User, :count).by(1)
    mail = ActionMailer::Base.deliveries.last
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
    expect(page).to have_content 'メールアドレスが確認できました。'
  end

  scenario "ゲストログイン" do
    visit root_path
    click_link "ログイン"
    puts User.count
    expect { click_link "ゲストログイン" }.to change(User, :count).by(1)
    expect(page).to have_content "ゲストユーザーとしてログインしました。"
    click_link "ユーザーアイコン"
    click_link "ログアウト"
    click_link "ログイン"
    expect { click_link "ゲストログイン" }.to change(User, :count).by(0)
  end

end
