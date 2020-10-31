class CommunitiesController < ApplicationController
  layout 'maps'

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :show, :community_participation]
  before_action :set_target_community, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]
  before_action :set_search, only: [:index]

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

  def index
    @communities = Community.page(params[:page]).includes(:room).order(updated_at: "DESC")
    gon.user = current_user
    gon.communities = Community.all
  end

  def show
    @communities = Community.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @room = @community.room
    @community_users = @community.community_users.all
    @users = []
    @community_users.each do |users|
      @users.push(User.find(users.user_id))
    end
    gon.user = current_user
    gon.community = @community
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

  def search_community
    @q = Community.ransack(params[:q])
    grouping_hash = params[:q][:community_place_or_community_date_or_community_limit_or_community_money_or_community_all_tag_cont].split(",").reduce({}){|hash, word| hash.merge(word => { community_place_or_community_date_or_community_limit_or_community_money_or_community_all_tag_cont: word })}
    @communities = Community.ransack({ combinator: 'and', groupings: grouping_hash }).result.includes(:room).order(updated_at: "DESC").page(params[:page])
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

  def set_search
    @q = Community.ransack(params[:q])
  end

end
