class UserMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def appeared_idea
    @user = params[:user]
    @idea = params[:idea]
    mail(to: @user.email, subject: 'Appeared new idea')
  end

end
