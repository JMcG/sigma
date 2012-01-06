module Sigma
  class CatalogRequest < TransactionSet

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