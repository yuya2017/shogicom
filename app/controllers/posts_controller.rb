class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :show]
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]
  before_action :set_search, only: [:index, :search_post]
  def new
    @post = Post.new
    @post.build_room
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to root_path, notice: "#{@post.room.room_name}を作成しました。"
    else
      render "posts/new"
    end
  end

  def index
    @posts = Post.page(params[:page]).includes(:room, :user).order(updated_at: "DESC")
  end

  def show
    @room = @post.room
  end

  def edit
  end

  def update
    #要テスト
    unless @post.room.id == params[:post][:room_attributes][:id].to_i
      redirect_to root_path, notice: "room_idは変更できません。"
    end
    if @post.update(post_params)
      redirect_to root_path, notice: "更新しました。"
    else
      render "posts/edit"
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path, notice: "#{@post.room.room_name}を削除しました。"
    else
      render "posts/edit"
    end
  end

  def search_post
    grouping_hash = params[:q][:post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont].split(",").reduce({}){|hash, word| hash.merge(word => { post_chess_or_post_app_or_post_time_or_post_all_tag_or_room_room_name_cont: word })}
    @posts = Post.ransack({ combinator: 'and', groupings: grouping_hash }).result.includes(:room, :user).order(updated_at: "DESC").page(params[:page])
  end

  private

  def post_params
    params.require(:post).permit(:post_chess, :post_app, :post_time, :post_all_tag, :post_content, room_attributes:[:id, :room_name])
  end

  def set_target_post
    @post = Post.find(params[:id])
  end

  def account_confirmation
    unless current_user.id == @post.user_id
      redirect_to root_path, notice: "このアカウントは操作できません。"
    end
  end

  def set_search
    @q = Post.ransack(params[:q])
  end

end
