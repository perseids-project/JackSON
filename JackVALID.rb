require 'pathname'
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
  
  private_class_method :new
  
end