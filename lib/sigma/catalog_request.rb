module Sigma
  class CatalogRequest < TransactionSet
    attr_reader :request_fields, :request_options
    SIGMA_REQUEST_FIELDS = %w(transaction_code tpol_transaction_code control_block customer_number order_number company_name billing_first_name billing_last_name billing_street_number billing_street_name billing_unit_number billing_address_additional billing_city billing_state billing_zip country_desc email_address order_type source_code)

    def initialize(options={})
      @request_fields = SIGMA_REQUEST_FIELDS + TransactionSet::SIGMA_REQUEST_FIELDS

      @request_options = {:transaction_id => transaction_id, 
                          :company_number => company_number}.merge(options)
    end

    def parse_response(raw_response)
      #i.e. [raw_response.split('|')]
      [raw_response.split('|')]
    end
    
    def success?
      catalog_request.response_code == "000"
    end
    
    def error_message
      return "" if success?
      catalog_request.error_message.strip
    end
    
    def catalog_request
      @catalog_request ||= response.collection[0]
    end
    
  end
end