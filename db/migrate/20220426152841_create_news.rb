class CreateNews < ActiveRecord::Migration[7.0]
  def change
    create_table :news do |t|
      t.string :title
      t.integer :available_to, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.text :abstract
      t.text :body
      t.string :location
      t.datetime :added, now: true
      t.datetime :published_at, null: true
      t.boolean :important, null:false, default: false
      t.timestamps

      t.belongs_to :author, :model_name => "User"


      t.index :status
      t.index :important
    end
  end
end
