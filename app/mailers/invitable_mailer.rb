class InvitableMailer < ActionMailer::Base

  def invite_user(user, root_url)
    @user     = user
    @token    = user.raw_invitation_token
    @root_url = root_url
    @invitation_link = accept_user_invitation_url(:invitation_token => @token)

    mail(from: "no-reply@rcr.com", to: @user.email, subject: 'User Invitation',  template_path: 'mailers/devise')
  end
  
end
