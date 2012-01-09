module Sigma
  class Request
    attr_reader :fields
    
    def initialize(transaction)
      request_class = class << self; self; end
      request_class.instance_eval do
        transaction.request_fields.each do |field|
          define_method("#{field}"){ RequestField.new(field, transaction) }
        end
      end
      @fields = []
      singleton_methods.map{|sm| send(sm)}.each {|f| @fields[f.position] = f }
    end
    
    def to_s
      return yield(fields.join("|")) if block_given?
      return fields.join("|")
    end
    
  end
end