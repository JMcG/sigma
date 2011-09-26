module Sigma
  class Api
    attr_accessor :transaction

    def initialize(transaction)
      @transaction = transaction
    end
    
    def method_missing(name, *args)
      super unless @transaction.respond_to? name
      @transaction.send name, *args
    end
    
  end
end