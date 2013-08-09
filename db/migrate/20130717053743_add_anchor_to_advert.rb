class AddAnchorToAdvert < ActiveRecord::Migration
  def change
    add_column :adverts, :anchor, :string
  end
end
