class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.float :rate
      t.integer :number_rated
      t.belongs_to :news, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
