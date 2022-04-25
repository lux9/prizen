class AddPicLinkColumnToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :pic_link, :string
  end
end
