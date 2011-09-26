module Sigma
  class TransactionSet
    SIGMA_REQUEST_FIELDS = %w(transaction_id company_number)

    def transaction_id
      Array.new(10).map { (1 + rand(9)) }.join
    end
    
    def company_number
      80
    end
    
    def yaml_fields
      return @yaml_fields if @yaml_fields
      @yaml_fields = Sigma.load_file(Sigma.underscore(self.class.name))
    end
    
    def request
      return @request if @request
      @request = Request.new(self)
    end
    
    def response
      return @response if @response
      @response = Response.new(Sigma.send(request.to_s{|x| x + add_ons }), self)
    end
    
    def response_scope(*args)
      nil
    end
    
    def add_ons
      ""
    end
    
  end
end