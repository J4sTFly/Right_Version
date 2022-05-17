class AddApproveToNews < ActiveRecord::Migration[7.0]
  def change
    add_column :news, :approved, :boolean, null: false, default: false
  end
end
