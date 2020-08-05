class AddMissedColumnMonto < ActiveRecord::Migration[5.2]
  def change
    add_column :orders , :monto, :float
  end
end
