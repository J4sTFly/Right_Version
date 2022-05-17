class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :news, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.references :parent_comment, foreign_keys: { to_table: :comments }
      t.timestamps
    end
  end
end
