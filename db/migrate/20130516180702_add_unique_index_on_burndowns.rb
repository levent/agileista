class AddUniqueIndexOnBurndowns < ActiveRecord::Migration
  def up
    execute("delete from burndowns where (created_on,sprint_id) in (select created_on,sprint_id
            from burndowns
            group by created_on,sprint_id having count(*) > 1);");
    remove_index :burndowns, :name => "index_burndowns_on_sprint_id_and_created_on"
    add_index "burndowns", ["sprint_id", "created_on"], :name => "index_burndowns_on_sprint_id_and_created_on", :unique => true
  end

  def down
  end
end
