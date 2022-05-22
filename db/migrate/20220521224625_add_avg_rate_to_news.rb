class AddAvgRateToNews < ActiveRecord::Migration[7.0]
  def change
    add_column :news, :avg_rate, :float, default: 0
  end
end
