class AddIndexToNews < ActiveRecord::Migration[7.0]
  def change
    add_index :news, :available_to
  end
end
