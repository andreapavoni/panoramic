class CreateDatabaseTemplates < ActiveRecord::Migration
  def self.up
    create_table :database_templates do |t|
      t.text :body
      t.boolean :partial, :default => false
      t.string :path
      t.string :format
      t.string :locale
      t.string :handler

      t.timestamps
    end
  end

  def self.down
    drop_table :database_templates
  end
end
