class AddGitRepoToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :git_repo, :string
  end

  def self.down
    remove_column :projects, :git_repo
  end
end
