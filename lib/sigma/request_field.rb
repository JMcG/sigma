module Sigma
  class RequestField < Request
    attr_reader :name, :value, :position
    
    def initialize(name, transaction)
      options = transaction.yaml_fields['RequestField']["#{name}"]
      options[:value] = transaction.request_options[name.to_sym]
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      @value = @default if @default and !@value
      validate_request_options
    end
    
    def validate_request_options
      raise Exception, "The value '#{@value}' is not an acceptable option for '#{name}', options => #{@options}" if @options and !@options.match(value)
      raise Exception, "The value for #{name} is required" if !@value and @required
      raise Exception, "The value '#{@value}' is not an acceptable format for '#{name}', format => #{@format}" unless format_is_valid?
    end
    
    def format_is_valid?
      return true if !@value #and required = false
      
      size, type = @format.split("/")
      return false if @value.to_s.length > size.to_i
      
      if type == "A"
        return true if @value.instance_of? String
      elsif type == "N"
        return true if Float(@value) rescue false
      else
        raise Exception, "Undefined format, #{type}"
      end
    end
    
    def to_s
      value.to_s || ""
    end
    
    def <=>(other)
      position <=> other.position
    end
    
  end
end