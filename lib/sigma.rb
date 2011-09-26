require "sigma/version"
require 'sigma/api'
require 'sigma/transaction_set'
require 'sigma/request'
require 'sigma/request_field'
require 'sigma/response'
require 'sigma/zip_code_lookup'
require 'sigma/product_availability'

module Sigma
  require 'socket'
  require 'yaml'
  
  HOST  = '172.16.200.140'
  
  def self.port
    14000 + rand(39)
  end
  
  def self.send(request)
    TCPSocket.open(HOST,Sigma.port) do |s|
      s.print request + "<EOT>"
      s.read
    end
  end
  
  def self.underscore(str)
    str.gsub(/Sigma::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  
  def self.load_file(name)
    YAML.load(File.open("yaml_files/#{name}.yml"))
  end
  
end