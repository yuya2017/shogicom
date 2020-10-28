class TopsController < ApplicationController

  def index
    @posts = Post.all.includes(:room).order(updated_at: "DESC").limit(10)
    @tournaments = Tournament.all.includes(:room).order(updated_at: "DESC").limit(10)
    @communities = Community.all.includes(:room).order(updated_at: "DESC").limit(10)
    gon.user = current_user
    gon.communities = Community.all
  end

  def mypage
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @tournaments = @user.tournaments.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @communities = @user.communities.page(params[:page]).includes(:room).order(updated_at: "DESC").limit(10)
  end
end
