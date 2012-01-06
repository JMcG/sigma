module Sigma  
  class ZipCodeLookup < TransactionSet
    
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