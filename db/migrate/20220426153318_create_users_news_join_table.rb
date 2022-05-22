class CreateUsersNewsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :news do |t|
      t.index :user_id
      t.index :news_id
    end
  end
end
