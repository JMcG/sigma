module Sigma
  # This is the super class of all Api transactions available.  This class takes care of all of the things that every Api provided by sigma has in common.
  # Keep in mind all of these methods can be over-ridden when necessary in it's sub transaction classes.. One common example would be to se the the company_number to use a something different
  # for certain Api's when testing or debugging.
  #  
  class TransactionSet
    # Every request sent to sigma will have a transaction_id and a company number, to avoid duplication when creating new Api's these are defined here.
    SIGMA_REQUEST_FIELDS = %w(transaction_id company_number)
    
    # This will return a random number 10 digits in length
    def transaction_id
      Array.new(10).map { (1 + rand(9)) }.join
    end
    
    # The defaul company number that will be used by all Api's
    def company_number
      80
    end
    
    # This will return a hash loaded from a yaml file which is determined by the name of the recievers class.
    #   api = Sigma::Api.new(Sigma::ZipCodeLookup.new(:zip_code => "56007"))
    #   api.yaml_fields       => {"RequestField"=>{"transaction_code"=>{"name"=>"transaction_code", "format"=>"4/A", "default"=>"1R", "position"=>0}, "transaction_id"=>{"name"=>"transaction_id", "format"=>"20/A", "position"=>1}, "company_number"=>{"name"=>"company_number", "format"=>"2/N", "position"=>2}, "zip_code"=>{"name"=>"zip_code", "format"=>"9/A", "position"=>3}}, "ResponseField"=>{"transaction_code"=>"0", "transaction_id"=>"1", "response_code"=>"2", "city"=>"3", "state"=>"4"}}
    def yaml_fields
      return @yaml_fields if @yaml_fields
      @yaml_fields = Sigma.load_file(Sigma.underscore(self.class.name))
    end
    
    # This will return the Request object from memory, or it will be created if doesn't exists.
    def request
      return @request if @request
      @request = Request.new(self)
    end

    # This will return the Response object from memory, or it will be created if doesn't exists.
    def response
      return @response if @response
      @response = Response.new(Sigma.send(request.to_s{|x| x + add_ons }), self)
    end
    
    # Basically acts as an abstract method, may replace in the future.  
    # Certain api's accept parameters which effect the format of the raw response returned from sigma. For any new api classes that are created 
    # which fall into this category you can define this method in that class definition.  See the Sigma::ProductAvailability api for an example
    def response_scope(*args)
      nil
    end
    
    # Like response_scope this method asically acts as an abstract method and should also be implemented in an api's class definition when needed.
    # The request sent to sigma will include whatever this method returns to the end of the request before the <EOT> flag.
    def add_ons
      ""
    end
    
  end
end