class CreateUsersIdeasJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :ideas do |t|
      t.index :user_id
      t.index :idea_id
    end
  end
end
