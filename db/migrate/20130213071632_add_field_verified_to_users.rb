class AddFieldVerifiedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :verified, :boolean, :default => '0'
  end

  def self.dowm
    remove_column :users, :verified
  end
end
