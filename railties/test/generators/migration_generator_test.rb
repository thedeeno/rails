require 'generators/generators_test_helper'
require 'rails/generators/rails/migration/migration_generator'

class MigrationGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper

  def test_migration
    migration = "change_title_body_from_posts"
    run_generator [migration]
    assert_migration "db/migrate/#{migration}.rb", /class ChangeTitleBodyFromPosts < ActiveRecord::Migration/
  end

  def test_migration_with_class_name
    migration = "ChangeTitleBodyFromPosts"
    run_generator [migration]
    assert_migration "db/migrate/change_title_body_from_posts.rb", /class #{migration} < ActiveRecord::Migration/
  end

  def test_add_migration_with_attributes
    migration = "add_title_body_to_posts"
    run_generator [migration, "title:string", "body:text"]

    assert_migration "db/migrate/#{migration}.rb" do |content|
      assert_class_method :up, content do |up|
        assert_match /add_column :posts, :title, :string/, up
        assert_match /add_column :posts, :body, :text/, up
      end

      assert_class_method :down, content do |down|
        assert_match /remove_column :posts, :title/, down
        assert_match /remove_column :posts, :body/, down
      end
    end
  end

  def test_remove_migration_with_attributes
    migration = "remove_title_body_from_posts"
    run_generator [migration, "title:string", "body:text"]

    assert_migration "db/migrate/#{migration}.rb" do |content|
      assert_class_method :up, content do |up|
        assert_match /remove_column :posts, :title/, up
        assert_match /remove_column :posts, :body/, up
      end

      assert_class_method :down, content do |down|
        assert_match /add_column :posts, :title, :string/, down
        assert_match /add_column :posts, :body, :text/, down
      end
    end
  end
end
