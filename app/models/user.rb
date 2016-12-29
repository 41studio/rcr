class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  belongs_to :role

  def is_manager?
    role.name.eql?("manager")
  end

  def is_helper?
    role.name.eql?("helper")
  end
end
