class Api::TournamentUsersController < ApplicationController

    def index
        tournament_users = TournamentUser.all
        render json: tournament_users
    end

end