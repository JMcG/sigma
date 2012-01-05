module Sigma
  class CustomerActivitySummary < TransactionSet
    attr_reader :request_fields, :request_options
    SIGMA_REQUEST_FIELDS = %w(transaction_code customer_number activity_number_type customer_password activity_number return_data_types max_returned)

    def initialize(options={})
      @request_fields = SIGMA_REQUEST_FIELDS + TransactionSet::SIGMA_REQUEST_FIELDS

      @request_options = {:transaction_id => transaction_id, 
                          :company_number => company_number}.merge(options)
    end

    def parse_response(raw_response)
      rr = raw_response.split('|')
      customer = rr.slice(0..16)
      activity_summaries = rr.slice(17..-3).each_slice(12).to_a
      [customer] + activity_summaries
    end

    def customer
      @customer ||= response.collection[0]
    end

    def activity_summaries
      @activity_summaries ||= response.collection.slice(1..-1)
    end

  end
end