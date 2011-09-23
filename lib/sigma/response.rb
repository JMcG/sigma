module Sigma
  class Response
    attr_accessor :collection
    
    def initialize(raw_response, transaction)
      @raw_response = raw_response
      @transaction = transaction
      @collection = []
      
      collection = Class.new(Array) do
        def initialize(array, transaction)
          @transaction = transaction
          super(array)
        end
        
        def method_missing(name, *args)
          # index = I18n.t(name, :scope => ["#{@transaction.class}", "TransactionSet", "ResponseField"] + @transaction.response_scope, :default => -1)
          index = @transaction.response_scope(name)
          index = @transaction.yaml_fields['ResponseField']["#{name}"] || -1 unless index
          return super unless index != -1
          return self[index.to_i]
        end
        
      end
      @transaction.parse_response(raw_response).each { |array| @collection << collection.new(array, transaction) }  
    end
    
    def method_missing(name, *args)
      super unless @transaction.respond_to? name
      @transaction.send name, *args
    end
    
  end
end