module WhosGotDirt
  # Renders a template in the context of a binding.
  #
  # In this gem's case, the template is a hash in which some values are
  # [JSONPath](http://goessner.net/articles/JsonPath/) expressions, and the
  # binding is a Ruby data structure loaded from a JSON source. The JSONPath
  # expressions are evaluated against the binding to render the template.
  #
  # @example
  #   renderer = WhosGotDirt::Renderer.new({'name' => '$.fn'})
  #   b = {'fn' => 'John Smith'}
  #   renderer.result(b)
  #   #=> {'name' => 'John Smith'}
  #
  # @see http://ruby-doc.org/stdlib-2.2.3/libdoc/erb/rdoc/ERB.html
  class Renderer
    attr_reader :template

    # Sets the template.
    #
    # @param [Object] a template
    def initialize(template)
      @template = template
    end

    # Renders the template in the context of the binding.
    #
    # @param [Object] a binding
    # @return [Object] the rendered template
    def result(b)
      walk(template, b)
    end

  private

    # @see https://github.com/pudo/jsonmapping/blob/master/jsonmapping/mapper.py
    def walk(node, b)
      case node
      when Hash
        node.tap do |hash|
          hash.each do |key,value|
            node[key] = walk(value, b)
          end
        end
      when Array
        node.map do |child|
          walk(child, b)
        end
      when String
        if node.start_with?('$')
          JsonPath.new(node).first(b)
        else
          node
        end
      else
        node
      end
    end
  end
end
