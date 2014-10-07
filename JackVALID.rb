require 'pathname'
require_relative 'JackHELP.rb'

class JackVALID
  
  # Holds the two structures to be compared
  @json = {}
  @validator = {}
  
  # Singleton magic
  @@run = JackVALID.new
  def self.run
    return @@run
  end
  
  # Validate a JSON file.
  # see docs/APP.md ### Validate uploaded JSON
  def check( path )
  end
  
  # Retrieve JSON file and validator.
  # JackVALID.run.pair( 'test/data/sample', 'test/validate/sample' )
  def pair( json, validator )
    if ( @json != nil &&
      @json[:path] = json && 
      @validator != nil &&
      @validator[:path] = validator )
      return
    end
    @json = {
      :path => json,
      :data => JackHELP.run.hashit( json )
    }
    @validator = {
      :path => validator,
      :data => JackHELP.run.hashit( validator )
    }
  end
  
  # JackVALID.run.context( 'test/data/sample', 'test/validate/sample' )
  def context( json, validator )
    pair( json, validator )
    if @validator[:data].has_key?('@context') == false
      return true
    end
    if @json[:data].has_key?('@context') == false
      throw "#{@json[:path]} is missing @context"
    end
    if @json[:data]['@context'] != @validator[:data]['@context']
      throw "#{@json[:path]} and #{@validator[:path]} have different @context"
    end
    return true
  end
  
  # JackVALID.run.regex( 'test/data/sample', 'test/validate/sample' )
  def regex()
    pair( json, validator )
  end
  
  # JackVALID.run.type( 'test/data/sample', 'test/validate/sample' )
  def type( json, validator )
    pair( json, validator )
    @validator[:data].each do |key, val|
      next if key == '@context'
      if @json[:data].has_key?(key) == false
        throw "#{@json[:path]} is missing key '#{key}'"
      end
      data = @json[:data][key]
      # Not sure exactly how to enforce data-types?
      # We're talking Javascript types not Ruby types here.
      type = val["type"].upcase
      case type
      when "STRING"
      when "INTEGER" 
      when "FLOAT"
      when "ARRAY"
      else
        throw "#{type} is not a valid data-type"
      end
    end
    return true
  end
  
  private_class_method :new
  
end