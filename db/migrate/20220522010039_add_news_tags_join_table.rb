class AddNewsTagsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :news, :tags do |t|
      t.index :tag_id
      t.index :news_id
    end
  end
end
