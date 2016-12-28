class UserSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :email, :role_id, :role

  def role
    object.role.name
  end

end