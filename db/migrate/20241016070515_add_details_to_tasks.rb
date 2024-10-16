class AddDetailsToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :tag_list, :string
    add_column :tasks, :assigned_user_id, :integer
    add_index :tasks, :assigned_user_id
  end
end
