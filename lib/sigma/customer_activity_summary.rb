module Sigma
  class CustomerActivitySummary < TransactionSet

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