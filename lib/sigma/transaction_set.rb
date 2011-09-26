module Sigma
  class TransactionSet < Api
    SIGMA_REQUEST_FIELDS = %w(transaction_id company_number)
    
    attr_reader :request, :response, :yaml_fields
    attr_accessor :transaction
    
    def initialize
      if block_given?
        @transaction = yield
        @transaction.send_request
      end
      
    end
    
    def yaml_fields
      return @yaml_fields if @yaml_fields
      t_class = @transaction.class.name if @transaction
      @yaml_fields = Sigma.load_file(Sigma.underscore(t_class || self.class.name))
    end
    
    def request
      return @request if @request
      @request = Request.new(self)
    end
    
    def send_request
      @response = Response.new(Sigma.send(request.to_s{|x| x + add_ons }), self)
    end
    
    def response_scope(*args)
      nil
    end
    
    def add_ons
      ""
    end
    
    def method_missing(name, *args)
      super unless @transaction.respond_to? name
      @transaction.send name, *args
    end
    
  end

end