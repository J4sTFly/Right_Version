class CommentController < ApplicationController
  before_action :authenticate_user!
  before_action :find_comment, only: %i[update destroy show create_under_comment show_under_comment]

  def create
    idea = Idea.find_by id: params[:idea_id]
    if idea.present?
      comment = Comment.new(**comment_params, idea: idea, user: current_user)
      if comment.save
        render json: {
          status: { code: 200 },
          data: comment
        }
      else
        render json: {
          status: { code: 400 },
          data: comment.errors.full_messages
        }
      end
    else
      not_comment
    end
  end

  def update
    if @comment.present?
      if @comment.update(comment_params) && test_belong_to_user
        render json: {
          status: { code: 200, message: 'Comment updated successfully' }
        }
      else
        render json: {
          status: { code: 400 },
          data: @comment.errors.full_messages
        }
      end
    else
      not_comment
    end
  end

  def destroy
    if @comment.present? && test_belong_to_user
      @comment.destroy
      render json: {
        status: { code: 200, message: "Comment deleted successfully" }
      }
    else
      render json: {
        status: { code: 400, message: "This comment doesn't exist or it's action forbidden" }
      }
    end
  end

  def show
    if @comment.present?
      render json: {
        status: { code: 200 },
        data: @comment
      }
    else
      render json: {
        status: { code: 400, message: "This comment doesn't exist" }
      }
    end
  end

  def show_comment_to_idea
    idea = Idea.find_by id: params[:idea_id]
    if idea.present? && idea.comments.present?
      render json: {
        status: { code: 200 },
        data: idea.comments
      }
    else
      render json: {
        status: { code: 400, message: "This idea doesn't exist or comments for him absent" }
      }
    end
  end

  def show_under_comment
    if @comment.present? && @comment.comments.present?
      render json: {
        status: { code: 200 },
        data: @comment.comments
      }
    else
      render json: {
        status: { code: 400, message: "This comment doesn't exist or comments for him absent" }
      }
    end
  end

  def create_under_comment
    child_comment = Comment.new(**comment_params, idea: @comment.idea,
                                user: current_user, parent_comment: @comment)
    if child_comment.save
      render json: {
        status: { code: 200 },
        data: child_comment
      }
    else
      render json: {
        status: { code: 400 },
        data: child_comment.errors.full_messages
      }
    end
  end

  private

  def not_comment
    render json: {
      status: { code: 404, message: "This comment doesn't exist" }
    }
  end

  def comment_params
    params.require(:comment).permit(:description)
  end

  def find_comment
    @comment = Comment.find_by id: params[:id]
  end

  def test_belong_to_user
    return true if current_user.comments.find_by id: @comment.id || current_user.admin?

    false
  end
end
