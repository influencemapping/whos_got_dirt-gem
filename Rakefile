require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort 'YARD is not available. In order to run yard, you must: gem install yard'
  end
end

desc 'Fetch schemas, rewrite references, and store locally'
task :schemas do
  require 'json'
  require 'open-uri'

  require 'json-schema'

  def process_value(value, definitions)
    url = value['$ref']
    if url
      name = url.rpartition('/')[2].chomp('.json#')
      value['$ref'] = "#/definitions/#{name}"
      define(name, url, definitions)
    end
  end

  def process_schema(url, definitions)
    schema = JSON.load(open(url).read)
    schema['properties'].each do |_,value|
      process_value(value, definitions)
      if value.key?('items')
        process_value(value['items'], definitions)
      end
    end
  end

  def define(name, url, definitions)
    unless definitions.key?(name)
      definitions[name] = {} # to avoid recursion
      definitions[name] = process_schema(url, definitions)
      definitions[name].delete('$schema')
      definitions[name].delete('id')
    end
  end

  definitions = {} # passed by reference

  %w(organization person).each do |name|
    define(name, "http://www.popoloproject.com/schemas/#{name}.json#", definitions)
  end

  schema = {
    '$schema' => 'http://json-schema.org/draft-03/schema#',
    'definitions' => definitions,
  }

  JSON::Validator.validate!(schema, {}, validate_schema: true)

  File.open(File.expand_path(File.join('..', 'schemas', 'popolo.json'), __FILE__), 'w') do |f|
    f.write(JSON.pretty_generate(schema))
  end
end
