module Sigma
  class Request
    attr_accessor :fields
    
    def initialize(transaction)
      request_class = class << self; self; end
      request_class.instance_eval do
        transaction.request_fields.each do |field|
          define_method("#{field}"){ RequestField.new(field, transaction) }
        end
      end
      self.fields = singleton_methods.map{|sm| send(sm)}
    end
    
    def to_s
      return yield(fields.sort.join("|")) if block_given?
      return fields.sort.join("|")
    end
    
  end
end