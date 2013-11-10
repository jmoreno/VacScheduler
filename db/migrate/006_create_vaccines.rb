class CreateVaccines < ActiveRecord::Migration
  def self.up
    create_table :vaccines do |t|
      t.string :short_name
      t.string :name
      t.text :description
      t.string :link_info
      t.timestamps
    end
  end

  def self.down
    drop_table :vaccines
  end
end
