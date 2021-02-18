json.posts do
  json.array! @posts do |post|
    json.extract! post, :id, :post_chess, :post_app, :post_time, :post_all_tag, :post_content, :created_at, :updated_at, :room, :user
  end
end
json.user do
  json.extract! @user, :id
end