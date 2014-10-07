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
  def regex( json, validator )
    pair( json, validator )
    @validator[:data].each do |key, val|
      next if key == '@context'
      next if val.has_key?('regex') == false
      next if @json[:data].has_key?(key) == false
      data = @json[:data][key]
      regex = Regexp.new(val['regex'])
      if data.respond_to?(:each)
        data.each do |item|
          if regex.match(item) == nil
            throw "Regex mismatch! #{item} [#{val['regex']}]"
          end
        end
      else
        if regex.match(data) == nil
          throw "Regex mismatch! #{data} [#{val['regex']}]"
        end
      end
    end
    return true
  end
  
  # JackVALID.run.type( 'test/data/sample', 'test/validate/sample' )
  def type( json, validator )
    pair( json, validator )
    @validator[:data].each do |key, val|
      next if key == '@context'
      next if @json[:data].has_key?(key) == false
      # Not sure exactly how to enforce data-types?
      # We're talking Javascript types not Ruby types here.
      data = @json[:data][key]
      type = val["type"].upcase
      case type
      when "STRING"
      when "INTEGER" 
      when "FLOAT"
      when "ARRAY"
        if data.kind_of?(Array) == false
          throw "#{data.inspect} is not an Array"
        end
      else
        throw "#{type} is not a valid data-type"
      end
    end
    return true
  end
  
  private_class_method :new
  
end