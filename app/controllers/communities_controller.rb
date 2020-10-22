class CommunitiesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :set_target_community, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]

  def new
    @community = Community.new
    @community.build_room
  end

  def create
    @community = current_user.communities.new(community_params)
    if @community.save
      flash[:notice] = "#{@community.user.user_name}がコミュニティーを応募しました。"
      Community.community_user_create(current_user.id, @community.id)
      redirect_to("/")
    else
      render("communities/new")
    end
  end

  def all_content
    @communities = Community.page(params[:page]).includes(:room).order(updated_at: "DESC")
  end

  def show
    @communities = Community.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @room = @community.room
  end

  def edit
  end

  def update
    if @community.update(community_params)
      flash[:notice] = "更新しました。"
      redirect_to("/")
    else
      render("communities/edit")
    end
  end

  def destroy
    if @community.destroy
      flash[:notice] = "「#{@community.room.room_name}」が削除されました。"
      redirect_to("/")
    else
      render("communities/edit")
    end
  end

  #コミュニティー参加用
  def community_participation
    room = Community.enterCommunity(current_user.id, params[:community].to_i)
    redirect_to("/rooms/#{room.id}")
  end

  private

  def community_params
    params.require(:community).permit(:community_place, :community_date, :community_limit, :community_money, :community_all_tag, :community_content, room_attributes:[:id, :room_name])
  end

  def set_target_community
    @community = Community.find(params[:id])
  end

  def account_confirmation
    unless current_user.id == @community.user_id
    flash[:notice] = "このアカウントは操作できません。"
      redirect_to("/")
    end
  end

end
