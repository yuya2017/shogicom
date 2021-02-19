json.array! @tournaments do |tournament|
  json.id tournament.id
  json.tournament_number_of_people tournament.tournament_number_of_people
  json.tournament_limit tournament.tournament_limit.to_s
  json.tournament_date tournament.tournament_date.to_s
  json.tournament_chess tournament.tournament_chess
  json.tournament_app tournament.tournament_app
  json.tournament_time tournament.tournament_time
  json.tournament_all_tag tournament.tournament_all_tag
  json.tournament_content tournament.tournament_content
  json.created_at tournament.created_at.to_s
  json.room tournament.room
  json.user tournament.user
end