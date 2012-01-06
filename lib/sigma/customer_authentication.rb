module Sigma  
  class CustomerAuthentication < TransactionSet
    
    def parse_response(raw_response)
      [raw_response.split("|")]
    end
    
    def customer
      return @customer if @customer
      response.collection.first
    end
    
  end
end