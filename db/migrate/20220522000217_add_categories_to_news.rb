class AddCategoriesToNews < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :news, :category, foreign_key: true
  end
end
