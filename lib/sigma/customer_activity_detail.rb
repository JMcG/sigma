module Sigma
  class CustomerActivityDetail < TransactionSet
    
    def parse_response(raw_response)
      rr = raw_response.split('|')
      rr.each_slice(5).to_a
    end
    
  end
end