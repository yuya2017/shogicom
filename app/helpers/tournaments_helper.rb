module TournamentsHelper

  def tournament_number_of_people_limit(tournament)
    participant = tournament.tournament_users.all
    tournament.tournament_number_of_people.nil? || tournament.tournament_number_of_people > participant.count
  end

end
