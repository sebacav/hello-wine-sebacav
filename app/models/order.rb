class Order < ApplicationRecord
  belongs_to :user
  # Se generan los modelos enum, para poder enviar datos ya sea por nombres o numeros
  # esto permite que se guarden numericamente en la base de datos, sin necesidad
  # de gastar string en ella y ahorrando una tabla relacional por cada una
  enum estado_pago: [:pagada, :no_pagada, :pendiente_de_pago]
  enum estado_orden: [:recibida, :en_preparacion, :en_reparto, :entregada]
end
