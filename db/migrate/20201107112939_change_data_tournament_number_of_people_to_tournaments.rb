class ChangeDataTournamentNumberOfPeopleToTournaments < ActiveRecord::Migration[6.0]
  def change
    change_column :tournaments, :tournament_number_of_people, :integer
  end
end
