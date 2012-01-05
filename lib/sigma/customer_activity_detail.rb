module Sigma
  class CustomerActivityDetail < TransactionSet
    attr_reader :request_fields, :request_options
    SIGMA_REQUEST_FIELDS = %w(transaction_code customer_number customer_password activity_number_type activity_number)

    def initialize(options={})
      @request_fields = SIGMA_REQUEST_FIELDS + TransactionSet::SIGMA_REQUEST_FIELDS

      @request_options = {:transaction_id => transaction_id, 
                          :company_number => company_number}.merge(options)
    end

    def parse_response(raw_response)
      rr = raw_response.split('|')
      rr.each_slice(5).to_a
    end
  end
end