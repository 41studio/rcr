class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  belongs_to :role

  def is_manager?
    role.name.eql?("manager")
  end

  def is_helper?
    role.name.eql?("helper")
  end

  def is_owner?
    role.name.eql?("owner")
  end

  def self.invite(user_params, current_user)
    self.invite!(email: user_params[:email]) do |u|
      u.name               = user_params[:name]
      u.role_id            = user_params[:role_id]
      u.company_id         = current_user.company_id
      u.skip_invitation    = true
      u.invitation_sent_at = Time.now.utc
      u.invited_by_type    = "User"
      u.invited_by_id      = current_user.id
    end
  end

end
