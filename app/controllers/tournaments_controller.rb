class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :show, :edit, :tournament_participation, :tournament_exit]
  before_action :set_target_tournament, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]
  before_action :set_search, only: [:index, :search_tournament]
  before_action :date_confirmation, only: :search_tournament

  def new
    @tournament = Tournament.new
    @tournament.build_room
  end

  def create
    @tournament = current_user.tournaments.new(tournament_params)
    if @tournament.save
      Tournament.tournament_user_create(current_user.id, @tournament.id,)
      redirect_to root_path, notice: "#{@tournament.room.room_name}を応募しました。やむを得ず中止する場合は必ずチャットルームへ一言連絡を入れてください。"
    else
      render "tournaments/new"
    end
  end

  def index
    @tournaments = Tournament.where("tournament_limit >= ?", Date.today).page(params[:page]).includes(:room, :user).order(updated_at: "DESC")
  end

  def show
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
    grouping_hash = params[:q][:tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont].split(",").reduce({}){|hash, word| hash.merge(word => { tournament_chess_or_tournament_app_or_tournament_time_or_tournament_all_tag_or_room_room_name_cont: word })}
    @tournaments = Tournament.ransack({ combinator: 'and', groupings: grouping_hash }).result.where(tournament_date:params[:q][:tournament_date_start].to_time.beginning_of_day..params[:q][:tournament_date_end].to_time.end_of_day).includes(:room, :user).order(updated_at: "DESC").page(params[:page])
  end

  #大会参加用
  def tournament_participation
    tournament = Tournament.enterTournament(current_user.id, params[:tournament].to_i)
    unless tournament == nil
      redirect_to "/rooms/#{tournament.room.id}/tournament", notice: "大会へ参加しました。"
    else
      redirect_to root_path, notice: "大会の応募が終了しているため参加できませんでした。"
    end
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

  def date_confirmation
    if params[:q][:tournament_date_start].blank? || params[:q][:tournament_date_end].blank?
      redirect_to tournaments_path, notice: "日付を入力してください。"
    end
  end

end
