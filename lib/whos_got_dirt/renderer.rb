module WhosGotDirt
  # Accepts a JSON template, which is a hash in which some values are
  # [JSON Pointers](http://tools.ietf.org/html/rfc6901). The template is
  # rendered by evaluating its JSON Pointers against JSON data.
  #
  # @example
  #   renderer = WhosGotDirt::Renderer.new('name' => '/fn')
  #   data = {'fn' => 'John Smith'}
  #   renderer.result(data)
  #   #=> {'name' => 'John Smith'}
  #
  # @see http://ruby-doc.org/stdlib-2.2.3/libdoc/erb/rdoc/ERB.html
  class Renderer
    # @!attribute [r] template
    #   @return [Hash] the template
    attr_reader :template

    # Sets the template.
    #
    # @param [Object] template a template
    def initialize(template)
      @template = template
    end

    # Renders the template by evaluating its JSON Pointers against JSON data.
    #
    # @param [Object] data the JSON data
    # @return [Object] the rendered template
    def result(data)
      walk(template, data)
    end

  private

    # @see https://github.com/pudo/jsonmapping/blob/master/jsonmapping/mapper.py
    def walk(node, data)
      case node
      when Hash
        hash = {}
        node.each do |key,value|
          if value.respond_to?(:call)
            k, v = value.call(data)
          else
            v = walk(value, data)
          end
          if v
            hash[k || key] = v
          end
        end
        hash
      when Array
        node.map do |child|
          walk(child, data)
        end
      when String
        if node.start_with?('/')
          JsonPointer.new(data, node).value
        else
          node
        end
      else
        node
      end
    end
  end
end
