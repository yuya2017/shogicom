json.array! @users do |user|
    json.id user.id
    json.user_name user.user_name
  end