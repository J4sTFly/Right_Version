class CommentController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment, only: %i[show update destroy ]

  def index
    render json: Comment.all
  end

  def new
  end

  def create
    @comment =  Comment.create!(comment_params)
    save_comment
  end

  def show
    render @comment
  end

  def edit
  end

  def update
    if @comment.user == current_user
      @comment.update(comment_params)
      save_comment
    else
      render json: { message: "Access restricted" }
  end

  def destroy
    if @comment.user == current_user
      Comment.delete @comment.id
    else
      render json: { message: "Access restricted" }
    end
  end


  private

  def save_comment
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages
    end
  end

  def not_comment
    render json: {
      status: { code: 404, message: "This comment doesn't exist" }
    }
  end

  def comment_params
    params.require(:comment).permit!
  end

  def find_comment
    if params[:id].present?
      begin
      @comment = Comment.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render json: {message: "Comment not found"}
      end
    else
      render json: {message: "No id provided"}
    end
  end
end
