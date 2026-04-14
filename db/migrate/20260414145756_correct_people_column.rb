class CorrectPeopleColumn < ActiveRecord::Migration[8.1]
  def change
    rename_column :plans, :nb_peolpe, :nb_people
  end
end
