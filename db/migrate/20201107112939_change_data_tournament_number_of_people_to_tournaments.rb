class ChangeDataTournamentNumberOfPeopleToTournaments < ActiveRecord::Migration[6.0]
  def up
    change_column :tournaments, :tournament_number_of_people, 'integer USING CAST(tournament_number_of_people AS integer)'
  end

  def down
    change_column :tournaments, :tournament_number_of_people, :string
  end
end
