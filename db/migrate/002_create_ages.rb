class CreateAges < ActiveRecord::Migration
  def self.up
    create_table :ages do |t|
      t.string :short_name
      t.string :name
      t.integer :months
      t.timestamps
    end
  end

  def self.down
    drop_table :ages
  end
end
