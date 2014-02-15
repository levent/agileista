class SimplifyTasks < ActiveRecord::Migration
  def up
    sql = <<SQL
ALTER TABLE tasks ALTER COLUMN hours DROP DEFAULT;
ALTER TABLE tasks ALTER hours TYPE bool USING CASE WHEN hours=0 THEN true ELSE false END;
ALTER TABLE tasks ALTER COLUMN hours SET DEFAULT FALSE;
ALTER TABLE tasks rename COLUMN hours to done;
SQL
    execute(sql)
    add_index :tasks, [:user_story_id, :done]
  end

  def down
    sql = <<SQL
ALTER TABLE tasks ALTER COLUMN done DROP DEFAULT;
ALTER TABLE tasks ALTER done TYPE integer USING CASE WHEN done=true THEN 0 ELSE 1 END;
ALTER TABLE tasks ALTER COLUMN done SET DEFAULT 1;
ALTER TABLE tasks rename COLUMN done to hours;
SQL
    execute(sql)
  end
end
