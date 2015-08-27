class CreateDatabaseView < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW users_view AS SELECT u.id, u.name FROM users u
    SQL
  end

  def down
    execute 'DROP VIEW users_view'
  end
end
