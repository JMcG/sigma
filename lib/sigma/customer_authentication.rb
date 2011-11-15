module Sigma  
  class CustomerAuthentication < TransactionSet
    attr_reader :request_fields, :request_options
    
    SIGMA_REQUEST_FIELDS = %w(transaction_code first_name last_name street_name city email_address street_number company_name unit_number address_2 state zip_code customer_number)
    
    def initialize(options={})
      @request_fields = SIGMA_REQUEST_FIELDS + TransactionSet::SIGMA_REQUEST_FIELDS
      
      @request_options = {:transaction_id => transaction_id, 
                          :company_number => company_number}.merge(options)
    end
    
    def parse_response(raw_response)
      [raw_response.split("|")]
    end
    
    def customer
      return @customer if @customer
      response.collection.first
    end
    
  end
end