class AddImageUrlToPlan < ActiveRecord::Migration[8.1]
  def change
    add_column :plans, :image_url, :string
  end
end
