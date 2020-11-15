FactoryBot.define do
  factory :post do
    post_chess { "30級" }
    post_app { "将棋ウォーズ" }
    post_time { "10分" }
    post_all_tag { "誰でも可" }
    post_content { "制限なく募集します。" }
    association :user
  end
end
