class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name
      t.string :indexed_name
      t.text :definition
      t.string :language

      t.timestamps
    end
  end
end
