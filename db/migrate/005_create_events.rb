class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.text :notes
      t.integer :calendar_id
      t.integer :age_id
      t.integer :vaccine_id
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
