# encoding: UTF-8

begin
  require 'bundler'
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

ORMS = %w(active_record mongoid)

task :default => "spec:all"

namespace :spec do
  ORMS.each do |orm|
    desc "Run Tests against #{orm}"
    task orm do
      sh "BUNDLE_GEMFILE='gemfiles/#{orm}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{orm}.gemfile' bundle exec rake spec -t"
    end
  end

  desc "Run Tests against all ORMs"
  task :all do
    ORMS.each { |orm| Rake::Task["spec:#{orm}"].invoke }
  end
end
