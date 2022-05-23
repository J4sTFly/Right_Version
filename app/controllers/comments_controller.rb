class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment, only: %i[show update destroy ]
  before_action :author?, only: %i[show update destroy]
  before_action :admin?, only: %i[index]

  def index
    render json: Comment.all
  end

  def create
    @comment = Comment.new(comment_params)
    save_comment
  end

  def show
    render @comment
  end

  def update
    @comment.update(comment_params)
    save_comment
  end

  def destroy
    Comment.delete @comment.id
    render json: { message: "Deleted successfully" }
  end

  private

  def save_comment
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages
    end
  end

  def comment_params
    params.require(:comment).permit!
  end

  def find_comment
    if params[:id].present?
      begin
        @comment = Comment.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render json: { message: "Comment not found" }
      end
    else
      render json: { message: "No id provided" }
    end
  end

    def author?
      restrict unless @comment.user_id == current_user.id
    end
end
