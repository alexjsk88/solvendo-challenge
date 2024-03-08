# frozen_string_literal: true

require 'rake/testtask'
require 'sequel'
require './config/services'
require './config/seeder'

task default: :test

Rake::TestTask.new do |task|
  task.libs << 'test'
  task.pattern = 'test/**/test_*\.rb'
  task.warning = false
end

namespace :db do
  desc 'Perform migration up to latest migration available'
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(Services[:database], 'db/migrations')
  end

  desc 'Run database seeds'
  task :seed, :environment do |_task, args|
    Seeder.run_seeds!(args[:environment])
  end
end
