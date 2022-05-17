class MakeUsernameUniq < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :username, :string, uniq: true
  end
end
