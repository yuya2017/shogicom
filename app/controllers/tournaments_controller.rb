class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :show]
  before_action :set_target_tournament, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]
  before_action :set_search, only: :index

  def new
    @tournament = Tournament.new
    @tournament.build_room
  end

  def create
    @tournament = current_user.tournaments.new(tournament_params)
    if @tournament.save
      Tournament.tournament_user_create(current_user.id, @tournament.id,)
      redirect_to root_path, notice: "#{@tournament.room.room_name}を応募しました。"
    else
      render "tournaments/new"
    end
  end

  def index
    @tournaments = Tournament.page(params[:page]).includes(:room).order(updated_at: "DESC")
  end

  def show
    @tournaments = Tournament.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @room = @tournament.room
    @tournament_users = @tournament.tournament_users.all
    @users = []
    @tournament_users.each do |users|
      @users.push(User.find(users.user_id))
    end
  end

  def edit
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to root_path, notice: "更新しました。"
    else
      render "tournaments/edit"
    end
  end

  def destroy
    if @tournament.destroy
      redirect_to root_path, notice: "#{@tournament.room.room_name}を削除しました。"
    else
      render "tournaments/edit"
    end
  end

  def search_tournament
    @q = Tournament.ransack(params[:q])
    grouping_hash = params[:q][:tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_cont].split(",").reduce({}){|hash, word| hash.merge(word => { tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_cont: word })}
    @tournaments = Tournament.ransack({ combinator: 'and', groupings: grouping_hash }).result.includes(:room).order(updated_at: "DESC").page(params[:page])
  end

  #大会参加用
  def tournament_participation
    room = Tournament.enterTournament(current_user.id, params[:tournament].to_i)
    redirect_to "/rooms/#{room.id}/tournament", notice: "大会へ参加しました。"
  end

  #脱退
  def tournament_exit
    user = TournamentUser.find_by(tournament_id: params[:tournament].to_i, user_id: current_user.id)
    user.destroy
    redirect_to root_path, notice: "大会から抜けました。"
  end

  private

  def tournament_params
    params.require(:tournament).permit(:tournament_chess, :tournament_app, :tournament_time, :tournament_all_tag, :tournament_content, :tournament_limit, :tournament_number_of_people, :tournament_at_date, :tournament_at_hour, :tournament_at_minute, room_attributes:[:id, :room_name])
  end

  def set_target_tournament
    @tournament = Tournament.find(params[:id])
  end

  def account_confirmation
    unless current_user.id == @tournament.user_id
      redirect_to root_path, notice: "このアカウントは操作できません。"
    end
  end

  def set_search
    @q = Tournament.ransack(params[:q])
  end


end
