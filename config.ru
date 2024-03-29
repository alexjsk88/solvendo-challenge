# frozen_string_literal: true

require 'rake'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post put patch delete options head]
  end
end

load 'Rakefile'

puts 'Running migrations'
Rake::Task['db:migrate'].invoke

puts 'Running seeds'
Rake::Task['db:seed'].invoke

require File.expand_path('application', __dir__)
API::Root.compile!
run API::Root
