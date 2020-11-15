class CommunitiesController < ApplicationController
  layout 'maps'

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :show, :community_participation]
  before_action :set_target_community, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]
  before_action :set_search, only: :index

  def new
    @community = Community.new
    @community.build_room
  end

  def create
    @community = current_user.communities.new(community_params)
    if @community.save
      Community.community_user_create(current_user.id, @community.id)
      redirect_to root_path, notice: "#{@community.room.room_name}を応募しました。やむを得ず中止する場合は必ずチャットルームへ一言連絡を入れてください。"
    else
      if @community.community_place == "存在しません"
        @community.community_place = nil
        render "communities/new"
      else
        render "communities/new"
      end
    end
  end

  def index
    @communities = Community.where("community_limit >= ?", Date.today).page(params[:page]).includes(:room, :user).order(updated_at: "DESC")
    gon.user = current_user
    gon.communities = @communities
  end

  def show
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
      redirect_to root_path, notice: "更新しました。"
    else
      render "communities/edit"
    end
  end

  def destroy
    if @community.destroy
      redirect_to root_path, notice: "#{@community.room.room_name}を削除しました。"
    else
      render "communities/edit"
    end
  end

  def search_community
    @q = Community.ransack(params[:q])
    grouping_hash = params[:q][:community_place_or_community_all_tag_or_room_room_name_cont].split(",").reduce({}){|hash, word| hash.merge(word => { community_place_or_community_all_tag_or_room_room_name_cont: word })}
    @communities = Community.ransack({ combinator: 'and', groupings: grouping_hash }).result.where(community_date:params[:q][:community_date_start].to_time.beginning_of_day..params[:q][:community_date_end].to_time.end_of_day).includes(:room, :user).order(updated_at: "DESC").page(params[:page])

    gon.user = current_user
    gon.communities = @communities
  end

  #イベント参加用
  def community_participation
    community = Community.enterCommunity(current_user.id, params[:community].to_i)
    unless community == nil
      redirect_to "/rooms/#{community.room.id}/community", notice: "イベントへ参加しました。"
    else
      redirect_to "/", notice: "イベントの応募が終了しているため参加できませんでした。"
    end
  end

  #脱退
  def community_exit
    user = CommunityUser.find_by(community_id: params[:community].to_i, user_id: current_user.id)
    user.destroy
    redirect_to root_path, notice: "イベントから抜けました。"
  end

  private

  def community_params
    params.require(:community).permit(:community_place, :community_date, :community_limit, :community_money, :community_number_of_people, :community_all_tag, :community_content, room_attributes:[:id, :room_name])
  end

  def set_target_community
    @community = Community.find(params[:id])
  end

  def account_confirmation
    unless current_user.id == @community.user_id
      redirect_to root_path, notice: "このアカウントは操作できません。"
    end
  end

  def set_search
    @q = Community.ransack(params[:q])
  end

  def date_confirmation
    if params[:q][:community_date_start].blank? || params[:q][:community_date_end].blank?
      redirect_to communities_path, notice: "日付を入力してください。"
    end
  end

end
