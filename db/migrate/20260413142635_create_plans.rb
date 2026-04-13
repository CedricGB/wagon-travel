class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.string :departure
      t.string :arrival
      t.integer :budget
      t.date :date_start
      t.date :date_end
      t.string :title
      t.text :content
      t.boolean :public
      t.integer :nb_peolpe
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
