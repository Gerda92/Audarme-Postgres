class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :company
      t.integer :counter
      t.integer :place

      t.timestamps
    end
  end
end
