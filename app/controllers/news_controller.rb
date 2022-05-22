class NewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_news, only: %i[update show destroy]
  before_action :author?, only: %i[update destroy]

  def index
    if user_signed_in?
      render json: News.authorized.order('title').page(params[:page])
    else
      render json: News.unauthorized.order('title').page(params[:page])
    end
  end

  def new
  end

  def create
    if current_user.correspondent?
      @news = News.new(news_params)
      save_news
    else
      restrict
    end
  end

  def edit
  end

  def update
    @news.update news_params
    save_news
  end

  def show
    case @news.available_to
    when 'nobody'
      authenticate_user!
      author?
    when 'authorized'
      authenticate_user!
    end
    render json: @news
  end

  def destroy
    News.delete @news.id
    render json: { message: "Deleted successfully" }
  end

  def list_unapproved
    if current_user.admin?
      render json: News.unapproved
    else
      restrict
    end
  end

  def approve
    if current_user.admin?
    # POST Request contains array of News' ids to approve
      params[:approve_list].each do |news_id|
        News.find(news_id).approve
      end
    else
      restrict
    end
  end

  private

  def news_params
    params.require(:news).permit!
  end

  def find_news
    #@news = params[:id].present? ? News.find(params[:id]) : render json: { message: "No id provided" }
    if params[:id].present?
      begin
        @news = News.published.find(params[:id])
      rescue RecordNotFound
        render json: {message: "News not found."}
      end
    else
      render json: { message: "No id provided" }
    end
  end

  def save_news
    if @news.save
      render json: @news
    else
      render json: @news.errors.full_messages
    end
  end

  def author?
    restrict unless @news.author.id == current_user.id
  end
end
