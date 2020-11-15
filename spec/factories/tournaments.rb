FactoryBot.define do
  factory :tournament do
    tournament_chess { "30級" }
    tournament_app { "将棋" }
    tournament_time { "10分" }
    tournament_limit { "2022/02/22".to_time }
    tournament_at_date { "2022/02/25" }
    tournament_at_hour { "12" }
    tournament_at_minute { "30" }
    tournament_number_of_people { 10 }
    tournament_all_tag { "誰でも可" }
    tournament_content { "宜しくお願いいたします。" }
    association :user

    trait :limit_before do
      tournament_limit { "2020/01/01".to_time }
    end
    trait :limit_today do
      tournament_limit { Date.today }
    end
    trait :date_before do
      tournament_limit { "2022/02/23".to_time }
      tournament_at_date { "2022/02/20" }
      tournament_at_hour { "12" }
      tournament_at_minute { "30" }
    end
    trait :date_same_limit do
      tournament_limit { "2022/02/22".to_time }
      tournament_at_date { "2022/02/22" }
      tournament_at_hour { "00" }
      tournament_at_minute { "00" }
    end
    trait :different_time do
      tournament_limit { "2022/02/22".to_time }
      tournament_at_date { "2022/02/22" }
      tournament_at_hour { "23" }
      tournament_at_minute { "59" }
    end
    trait :limit_over do
      tournament_limit { "2020/02/22".to_time }
      tournament_date { "2022/02/25".to_date }
      tournament_at_date { nil }
      tournament_at_hour { nil }
      tournament_at_minute { nil }
    end
  end
end
