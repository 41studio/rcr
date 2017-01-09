class InvitableMailer < ActionMailer::Base

  def invite_user(user, root_url)
    @user     = user
    @root_url = root_url 

    mail(from: "no-reply@rcr.com", to: @user.email, subject: 'User Invitation',  template_path: 'mailers/devise')
  end
  
end
