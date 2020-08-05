class UserSerializer < ActiveModel::Serializer
  #Se comenta el password_digest porque no es parte del modelo y no la deseamos mostrar tampoco
  attributes :id, :email, :nombre #, :password_digest
end
