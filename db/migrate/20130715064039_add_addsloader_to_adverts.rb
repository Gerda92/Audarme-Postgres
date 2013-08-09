class AddAddsloaderToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :addsloader, :string
  end
end
