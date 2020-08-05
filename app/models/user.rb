class User < ApplicationRecord
    has_many :orders
    # Es necesario agregar el has_secure_password, para indicar que es un modelo con password protegida
    has_secure_password
end
