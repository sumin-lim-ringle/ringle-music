class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :password
      t.integer :usable, default: 1
      t.timestamps
    end
  end
end
