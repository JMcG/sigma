module Sigma  
  class ProductAvailability < TransactionSet
    attr_reader :request_fields, :request_options
    
    SIGMA_REQUEST_FIELDS = %w(ship_to_zip transaction_code product_number source_code ship_to_state customer_number ship_method response_type division order_quantity)
    
    ## Parsing methods 
    S = proc { |r| [r.split("|")] }
        
    D = proc { |r| [r.split("|").collect! {|p| p.gsub("\t", "")}] }
        
    M = proc do |r|
          r = r.split("\t") ; r.pop ; r.shift
          r.collect!{|x| x.split("|")}.each{|x| x.shift}
        end
        
    #######################################
    
    def initialize(options={})
      @request_fields = SIGMA_REQUEST_FIELDS + TransactionSet::SIGMA_REQUEST_FIELDS
      
      if options[:product_number].instance_of? Array
        if options[:product_number].size == 1
          options[:product_number] = options[:product_number].to_s
        else
          options[:response_type] = "M"
          @product_number_array = options[:product_number]
          options[:product_number] = @product_number_array.shift.to_s
          @product_number_array.collect!{|x| ["\t#{x}","1"]}.flatten!
        end
      end
      
      @request_options = {:transaction_id => transaction_id, 
                          :company_number => company_number}.merge(options)
    end
    
    def add_ons
      return @product_number_array.join("|") if @product_number_array
      return ""
    end
    
    #Resposne type 'S' is the first half of 'D', so we use the same scope in the en.yml file.
    def response_scope(name)
      r_type = request.response_type.value == 'S' ? 'D' : request.response_type.value
      yaml_fields['ResponseField'][r_type.to_s][name.to_s] || -1
    end
    
    #This method will changed to super or be removed when going live, because everything will go to company 1
    def company_number
      1
    end
    
    def products
      return @products if @products
      response.collection
    end
    
    def parse_response(raw_response)
      eval(request.response_type.to_s).call raw_response
    end
    
  end
end