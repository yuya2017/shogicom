FactoryBot.define do
  factory :user do
    sequence(:user_name) { |n| "鈴木#{n}郎" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    user_chess { "30級" }
    user_app { "将棋" }
    user_time { "10分" }
    user_pref { "東京都" }
    user_content { "初心者ですが宜しくお願いいたします。" }
    password { "password" }
    confirmed_at { Time.now }
  end

  trait :invalid do
    user_name { nil }
  end

  trait :update do
    user_chess { "1級" }
  end

  trait :update_email do
    email { "update@example.com" }
  end

end
