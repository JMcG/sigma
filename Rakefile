require "bundler/gem_tasks"
require "rake/testtask"
require "active_support"
include ActiveSupport::Inflector

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.test_files = FileList['test/*_test.rb', 'test/sigma/*_test.rb']
  test.verbose = true
end

task :default => :test

desc "Deletes files associated with passed api"
task :destroy_api, :api_name do |t, args|
  api_name = args[:api_name]
  
  File.delete "lib/sigma/#{api_name}.rb"
  File.delete "lib/sigma/yaml_files/#{api_name}.yml"
  
end

desc "Creates file template for adding a new api"
task :create_api, :api_name do |t, args|
  api_name = args[:api_name]
  
  raise "The api `lib/sigma/#{api_name}.rb` already exists." if File.exists? "lib/sigma/#{api_name}.rb"
  raise "The api `lib/sigma/yaml_files/#{api_name}.yml` already exists." if File.exists? "lib/sigma/#{api_name}.rb"
  
  File.open("lib/sigma/#{api_name}.rb", 'w') do |f|
    f.write \
    "module Sigma\n" \
    "  class #{camelize(api_name)} < TransactionSet\n" \
    "\n" \
    "    def parse_response(raw_response)\n" \
    "      \#i.e. [raw_response.split('|')]\n\n" \
    "    end\n" \
    "  end\n" \
    "end"
  end
  puts "Created file at lib/sigma/#{api_name}.rb\n"
  
  File.open("lib/sigma/yaml_files/#{api_name}.yml", 'w') do |f|
    f.write \
    "RequestField:\n" \
    "  'transaction_code' : {name: 'transaction_code', format: '4/A', default: '', position: 0}\n" \
    "  'transaction_id' : {name: 'transaction_id', format: '20/A', position: 1}\n" \
    "  'company_number' : {name: 'company_number', format: '2/N', position: 2}\n" \
    "ResponseField:\n" \
    "  'transaction_code': '0'\n" \
    "  'transaction_id': '1'\n" \
    "  'response_code': '2'\n"
  end
  
  puts "Created file at lib/sigma/yaml_files/#{api_name}.yml\n"
  
end