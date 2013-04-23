class AddNameIndexToWords < ActiveRecord::Migration
  def change
  	add_index(:words, :indexed_name)
  end
end
