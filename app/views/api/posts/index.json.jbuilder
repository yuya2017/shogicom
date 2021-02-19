json.array! @posts do |post|
  json.id post.id
  json.post_chess post.post_chess
  json.post_app post.post_app
  json.post_time post.post_time
  json.post_all_tag post.post_all_tag
  json.post_content post.post_content
  json.created_at post.created_at.to_s
  json.room post.room
  json.user post.user
end