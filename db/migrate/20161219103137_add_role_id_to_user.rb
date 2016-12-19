class AddRoleIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :role, foreign_key: true

    ['manager', 'helper'].each do |role|
      Role.find_or_create_by({name: role})
    end
  end
end
