require 'pathname'
require_relative 'JackHELP.rb'

class JackVALID
  
  # Singleton magic
  @@run = JackVALID.new
  def self.run
    return @@run
  end
  
  # Validate a JSON file.
  # see docs/APP.md ### Validate uploaded JSON
  def check( path )
  end
  
  # Compare JSON file with validator.
  # JackVALID.run.compare( 'test/json/sample', 'test/validate/validate' )
  def compare( json, validator )
    json = JackHELP.run.hashit( json )
    valid = JackHELP.run.hashit( json )
    puts json.inspect
    puts valid.inspect
  end
  
  def context()
  end
  
  def regex()
  end
  
  def type()
  end
  
  private_class_method :new
  
end