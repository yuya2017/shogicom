class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy, :show]
  before_action :set_target_post, only: [:show, :edit, :update, :destroy]
  before_action :account_confirmation, only: [:edit, :update, :destroy]
  before_action :set_search
  def new
    @post = Post.new
    @post.build_room
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:notice] = "#{@post.user.user_name}が#{@post.room.room_name}を作成しました。"
      redirect_to("/")
    else
      render("posts/new")
    end
  end

  def all_content
    @posts = Post.page(params[:page]).includes(:room).order(updated_at: "DESC")
  end

  def show
    @posts = Post.page(params[:page]).includes(:room).order(updated_at: "DESC")
    @room = @post.room
  end

  def edit
  end

  def update
    #要テスト
    unless @post.room.id == params[:post][:room_attributes][:id].to_i
      flash[:notice] = "room_idは変更できません。"
      redirect_to("/")
    end
    if @post.update(post_params)
      flash[:notice] = "更新しました。"
      redirect_to("/")
    else
      render("posts/edit")
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "「#{@post.room.room_name}」が削除されました。"
      redirect_to("/")
    else
      render("posts/edit")
    end
  end

  def search_post
    @q = Post.ransack(params[:q])
    grouping_hash = params[:q][:post_chess_or_post_app_or_post_time_or_post_all_tag_cont].split(",").reduce({}){|hash, word| hash.merge(word => { post_chess_or_post_app_or_post_time_or_post_all_tag_cont: word })}
    @posts = Post.ransack({ combinator: 'and', groupings: grouping_hash }).result.includes(:room).order(updated_at: "DESC").page(params[:page])
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
    flash[:notice] = "このアカウントは操作できません。"
      redirect_to("/")
    end
  end

  def set_search
    @q = Post.ransack(params[:q])
  end

end
