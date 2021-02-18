class Api::TopsController < ApplicationController

  def index
    user = current_user
    render json: user
  end

  def mypage
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @tournaments = @user.tournaments.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @communities = @user.communities.page(params[:page]).includes(:room).order(updated_at: "DESC").limit(10)
  end
end
