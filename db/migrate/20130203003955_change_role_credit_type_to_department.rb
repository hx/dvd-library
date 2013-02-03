class ChangeRoleCreditTypeToDepartment < ActiveRecord::Migration
  def change
    change_table :roles do |t|
      t.rename :credit_type, :department
    end
  end
end
