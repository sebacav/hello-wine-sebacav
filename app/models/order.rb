class Order < ApplicationRecord
  belongs_to :user
  enum estado_pago: [:pagada, :no_pagada, :pendiente_de_pago]
  enum estado_orden: [:recibida, :en_preparacion, :en_reparto, :entregada]
end
