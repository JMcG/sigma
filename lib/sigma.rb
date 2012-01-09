# == Sigma Controller+ API
# ==== Ruby bindings for the "Controller+ Internet API's" provided by Fifth Gear (formerly Sigma Micro Corporation). The documentation for the API Transaction Set v9.3 provided by fifth gear is very helpful to fully understand and take advantage of this API.  It can be downloaded from their website http://www.infifthgear.com
# Work done by Justin Mcginnis <justin.mcginnis@gmail.com>
# 
# === Documentation & Examples
# To begin reviewing the available methods and examples, checkout the README file, or starting by looking at the documentation for the Sigma::Api Class.


module Sigma
  require 'socket'
  require 'yaml'
  
  require "sigma/version"
  require 'sigma/api'
  require 'sigma/transaction_set'
  require 'sigma/request'
  require 'sigma/request_field'
  require 'sigma/response'
  require 'sigma/zip_code_lookup'
  require 'sigma/product_availability'
  require 'sigma/customer_authentication'
  require 'sigma/customer_activity_summary'
  require 'sigma/customer_activity_detail'
  require 'sigma/catalog_request'
  require 'sigma/customer_order'
  
  def self.disable!
    @@disable_sigma = true
  end
  
  def self.enable!
    @@disable_sigma = false
  end
  
  def self.disabled?
    return true if defined? @@disable_sigma && @@disable_sigma
    return false
  end

  # The address where the controller+ api is listening for requests
  HOST  = '172.16.200.140'
  
  # The port over which the request will be sent to sigma.  There are currently 40 ports open on which sigma is listening for requests, this will return a random port for each subsequent requests.
  # only one request will be processed on each port at any given time.  If ports are busy, the request will que and fire when available. 
  def self.port
    14000 + rand(39)
  end
  
  # Open a socket connection on the specified host and sends the request, then returns the response
  def self.send(request)
    TCPSocket.open(HOST,Sigma.port) do |s|
      s.print request + "|<EOT>"
      s.read
    end
  end
  
  # Accepts a string and replaces camlecase with underscores, also will replace the Namespace wrapper Sigma:: if it exists.
  #
  #   Sigma.underscore("Sigma::ZipCodeLookup")
  #   => zip_code_looup
  #
  def self.underscore(str)
    str.gsub(/Sigma::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  
  # Loads and returns the specified yaml file, file must exist in sigma/yaml_files
  def self.load_file(name)
    yaml_file = File.expand_path(File.join(File.dirname(__FILE__), "sigma", "yaml_files", "#{name}.yml"))
    YAML.load(File.open("#{yaml_file}"))
  end
  
end