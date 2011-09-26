module Sigma
  class Request
    attr_accessor :fields
    
    def initialize(transaction)
      @fields = []
      transaction.request_fields.each do |field|
        @fields << Request.define_field(field, transaction).call
      end
    end
    
    def self.define_field(name, transaction)
      define_method(name) do 
        RequestField.new(name, transaction)
      end
    end
    
    def to_s
      return yield(fields.sort.join("|")) if block_given?
      return fields.sort.join("|")
    end
    
  end
end