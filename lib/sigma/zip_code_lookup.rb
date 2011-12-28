module Sigma  
  class ZipCodeLookup < TransactionSet
    attr_reader :request_fields, :request_options
    
    SIGMA_REQUEST_FIELDS = %w(zip_code transaction_code)
    
    def initialize(options={})
      @request_fields = SIGMA_REQUEST_FIELDS + TransactionSet::SIGMA_REQUEST_FIELDS
      
      @request_options = {:transaction_id => transaction_id, 
                          :company_number => company_number}.merge(options)
    end
    
    def parse_response(raw_response)
      raw_response = raw_response.split("|").uniq
      x = raw_response.select {|z| z.match(/.*,.*/)}
      first_three = raw_response.slice(0..2)
      x.collect! {|z| [first_three, z.split(",")].flatten}
    end
    
    def zip_codes
      @zip_codes ||= response.collection
    end
    
  end
end