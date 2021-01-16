class ChangeDataTournamentNumberOfPeopleToTournaments < ActiveRecord::Migration[6.0]

  if !Rails.env.test?
    def up
      change_column :tournaments, :tournament_number_of_people, 'integer USING CAST(tournament_number_of_people AS integer)'
    end

    def down
      change_column :tournaments, :tournament_number_of_people, :string
    end
  else
    def change
      change_column :tournaments, :tournament_number_of_people, :integer
    end
  end
end
