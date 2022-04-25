class CreatesProductsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :actual_price
      t.float :previous_price
      t.timestamps
      t.references :seller, foreign_key: true
    end
  end
end
