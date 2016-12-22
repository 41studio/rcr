class UserSerializer < ActiveModel::Serializer
  attributes :id, :company_id, :email, :role_id
end