module Sigma
  class Api
    attr_reader :transaction_set

    def initialize(transaction_set)
      @transaction_set = transaction_set
    end
    
    def transaction_id
      Array.new(10).map { (1 + rand(9)) }.join
    end
    
    def company_number
      80
    end
  end
end