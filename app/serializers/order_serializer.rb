class OrderSerializer < ActiveModel::Serializer
  attributes :id, :monto, :estado_pago, :estado_orden, :fecha_pago, :fecha_entrega
  has_one :user
end
