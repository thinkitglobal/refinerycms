if !defined?(ENGINE_PATH) || !ENGINE_PATH
  abort("ERROR: ENGINE_PATH must be defined and contain a path pointing to your engine's root.")
end

namespace :refinery do  
  namespace :testing do
    desc "Generates a dummy app for testing"
    task :dummy_app do
      require 'refinerycms'
      
      params = []
      params << "--database=#{ENV['DB']}" if ENV['DB']

      Refinery::DummyGenerator.start params
      
      # Load generated dummy app after generation - some of the follow
      # generators depend on Rails.root being available
      load File.join(ENGINE_PATH, 'spec/dummy/config/environment.rb')
      
      Refinery::CmsGenerator.start
      Refinery::CoreGenerator.start
      Refinery::ResourcesGenerator.start
      Refinery::PagesGenerator.start
      Refinery::ImagesGenerator.start
      
      system "bundle exec rake -f #{File.join(ENGINE_PATH, 'Rakefile')} app:railties:install:migrations app:db:drop app:db:create app:db:migrate app:db:seed app:db:test:prepare RAILS_ENV=development"
    end
    
    desc "Remove the dummy app used for testing"
    task :clean_dummy_app do
      system "rm -Rdf #{File.join(ENGINE_PATH, 'spec/dummy')}"
    end
    
    namespace :engine do
      desc "Initialize the testing environment"
      task :setup => [:init_test_database]

      task :init_test_database => [
        'app:db:migrate',
        'app:db:test:prepare'
      ]
    end
  end
end
