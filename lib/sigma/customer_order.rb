module Sigma
  class CustomerOrder < TransactionSet
    
    def initialize(options={})
      @line_items_request_fields = options.delete(:line_items)
      super
    end
    
    def add_ons
       return "|\t" + @line_items_request_fields.join("\t") if @line_items_request_fields
       return ""
     end
    
    def response
      @response ||= Response.new(Sigma.send(request.to_s{|x| x.split("|").join("|") + add_ons }), self)
    end

    def parse_response(raw_response)
      raw_response = raw_response.split('|')
      
      alternate_shipping_methods = raw_response.slice!(8..67).each_slice(4).to_a
      order = [raw_response.slice!(0..20)]
      line_items = raw_response.slice(0..-3).each_slice(4).to_a
      
      order + alternate_shipping_methods + line_items
    end
    
    def order 
      @order ||= response.collection[0]
    end
    
    def alternate_shipping_methods
      return @alternate_shipping_methods if @alternate_shipping_methods
      @alternate_shipping_methods = response.collection.slice(1..15)
      
      @alternate_shipping_methods.map! do |x| 
         x[0].empty? ? nil : x
      end
      
      return @alternate_shipping_methods.compact!
    end
    
    def line_items
      @line_items ||= response.collection.slice(16..-1).map{|x| x[0].gsub!("\t", ""); x}
    end
    
    def success?
      order.response_code == "000"
    end
    
    def error_message
      return nil if success?
      order.error_message.strip
    end
    
  end
end