class AddAnplToAdvert < ActiveRecord::Migration
  def change
    add_column :adverts, :anchor, :string
    add_column :adverts, :place, :integer
  end
end
