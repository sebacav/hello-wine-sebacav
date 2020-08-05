class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :nombre #, :password_digest
end
