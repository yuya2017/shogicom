class TournamentsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :set_target_tournament, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]

  def new
    @tournament = Tournament.new
    @tournament.build_room
  end

  def create
    @tournament = current_user.tournaments.new(tournament_params)
    if @tournament.save
      flash[:notice] = "#{@tournament.user.user_name}が大会を応募しました。"
      Tournament.tournament_user_create(current_user.id, @tournament.id,)
      redirect_to("/")
    else
      render("tournaments/new")
    end
  end

  def all_content
    @tournaments = Tournament.page(params[:page]).includes(:room).order(updated_at: "DESC")
  end

  def show
    @tournaments = Tournament.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @room = @tournament.room
  end

  def edit
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = "更新しました。"
      redirect_to("/")
    else
      render("tournaments/edit")
    end
  end

  def destroy
    if @tournament.destroy
      flash[:notice] = "「#{@tournament.room.room_name}」が削除されました。"
      redirect_to("/")
    else
      render("tournaments/edit")
    end
  end

  #大会参加用
  def tournament_participation
    room = Tournament.enterTournament(current_user.id, params[:tournament].to_i)
    redirect_to("/rooms/#{room.id}")
  end

  private

  def tournament_params
    params.require(:tournament).permit(:tournament_chess, :tournament_app, :tournament_time, :tournament_all_tag, :tournament_content, :tournament_limit, :tournament_number_of_people, :tournament_date, room_attributes:[:id, :room_name])
  end

  def set_target_tournament
    @tournament = Tournament.find(params[:id])
  end

  def account_confirmation
    unless current_user.id == @tournament.user_id
    flash[:notice] = "このアカウントは操作できません。"
      redirect_to("/")
    end
  end

end
