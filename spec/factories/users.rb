FactoryBot.define do
  factory :user do
    sequence(:user_name) { |n| "鈴木#{n}郎" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    user_chess { "30級" }
    user_app { "将棋" }
    user_time { "10分" }
    user_pref { 13 }
    user_content { "初心者ですが宜しくお願いいたします。" }
    password { "password" }
    confirmed_at { Time.now }
  end
end
