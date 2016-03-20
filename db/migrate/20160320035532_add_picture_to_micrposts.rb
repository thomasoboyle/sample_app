class AddPictureToMicrposts < ActiveRecord::Migration
  def change
    add_column :micrposts, :picture, :string
  end
end
