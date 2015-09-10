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
    ref = value['$ref']
    if ref
      key = ref.rpartition('/')[2].chomp('.json#')
      value['$ref'] = "#/definitions/#{key}"
      unless definitions.key?(key)
        definitions[key] = {} # to avoid recursion
        definitions[key] = process_schema(ref, definitions)

        definitions[key].delete('$schema')
        definitions[key].delete('id')
      end
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

    schema
  end

  %w(organization person).each do |name|
    definitions = {} # passed by reference
    schema = process_schema("http://www.popoloproject.com/schemas/#{name}.json#", definitions)
    schema['definitions'] = definitions
    JSON::Validator.validate!(schema, {}, validate_schema: true)
    File.open(File.expand_path(File.join('..', 'schemas', "#{name}.json"), __FILE__), 'w') do |f|
      f.write(JSON.pretty_generate(schema))
    end
  end
end
