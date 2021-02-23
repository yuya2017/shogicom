class Api::UsersController < ApplicationController

    def user_signed_in
        user = current_user
        render json: user
    end

    def index
        @users= User.all
    end

end