class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :estado_pago
      t.integer :estado_orden
      t.timestamp :fecha_pago
      t.timestamp :fecha_entrega
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
