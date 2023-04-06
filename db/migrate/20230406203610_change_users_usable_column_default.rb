class ChangeUsersUsableColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :usable, :integer, :default => 1
  end
end
