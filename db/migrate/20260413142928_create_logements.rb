class CreateLogements < ActiveRecord::Migration[8.1]
  def change
    create_table :logements do |t|
      t.string :name
      t.decimal :cost, precision: 7, scale: 2
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
