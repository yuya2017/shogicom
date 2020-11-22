FactoryBot.define do
  factory :tournament do
    tournament_chess { "30級" }
    tournament_app { "将棋ウォーズ" }
    tournament_time { "10分" }
    tournament_limit { Date.today >> 1 }
    tournament_at_date { Date.today >> 2 }
    tournament_at_hour { "12" }
    tournament_at_minute { "30" }
    tournament_number_of_people { 10 }
    tournament_all_tag { "誰でも可" }
    tournament_content { "宜しくお願いいたします。" }
    association :user

    trait :with_room do
      room_attributes { attributes_for(:room, :tournament_room) }
    end

    trait :with_update do
      tournament_chess { "1級" }
    end

    trait :invalid do
      tournament_chess { nil }
    end

    trait :limit_before do
      tournament_limit { Date.today << 1 }
    end

    trait :limit_today do
      tournament_limit { Date.today }
    end

    trait :date_before do
      tournament_limit { Date.today >> 2 }
      tournament_at_date { Date.today >> 1 }
      tournament_at_hour { "12" }
      tournament_at_minute { "30" }
    end

    trait :date_same_limit do
      tournament_limit { Date.today >> 1 }
      tournament_at_date { Date.today >> 1 }
      tournament_at_hour { "09" }
      tournament_at_minute { "00" }
    end

    trait :different_time do
      tournament_limit { Date.today >> 2 }
      tournament_at_date { Date.today + 1 >> 2 }
      tournament_at_hour { "08" }
      tournament_at_minute { "59" }
    end

    trait :limit_over do
      tournament_limit { Date.today << 1 }
      tournament_date { Date.today >> 2 }
      tournament_at_date { nil }
      tournament_at_hour { nil }
      tournament_at_minute { nil }
    end

  end
end
