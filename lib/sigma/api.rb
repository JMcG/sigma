module Sigma
  # This is the base class for all request to Sigma.  When creating a new Api object, it must be initialized with one of the available Api's.
  #
  #   api = Sigma::Api.new( Sigma::ZipCodeLookup.new(:zip_code => "55318") )
  #   api.transaction         => Sigma::ZipCodeLookup
  #
  # After the object is initiailzed however, you can swap out the Api request by setting the transaction type explicitly
  #
  #   api.transaction = Sigma::ProductAvailability.new(:product_number => [57337, 36774, 50093, 93939], :response_type => "M")
  #   api.transaction         => Sigma::ProductAvailability
  #
  # This class doesn't do much besides pass requests on to the associated trasaction object via the method_missing method.
  class Api
    attr_accessor :transaction

    def initialize(transaction)
      @transaction = transaction
    end
    
    # Checks to see if the requested method exists on the trasaction object and calls it if it does, or just calls super.
    def method_missing(name, *args)
      super unless @transaction.respond_to? name
      @transaction.send name, *args
    end
    
  end
end