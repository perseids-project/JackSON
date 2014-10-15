require 'pathname'
require 'JackRDF'
class JackHELP
  
  # Singleton magic
  @@run = JackHELP.new
  def self.run
    return @@run
  end
  
  # Get the local path to a JSON file from a relative URL
  def json_file( url )
    if url[-5..-1] != '.json'
      url = "#{url}.json"
    end
    Pathname.new( url ).cleanpath.to_s
  end
  
  # Return a ruby hash of a JSON file
  def hashit( file )
    if file == nil
      throw "No file was passed"
    end
    json = json_file( file )
    JSON.parse( File.read( json ) )
  end
  
  # Write a JSON file
  def write_json( data, file )
    File.open( file, "w+" ) do |f|
      f.write( data )
    end
  end
  
  # Get all files matching a regex
  def files_matching( dir, regex )
    files = []
    Find.find( dir ) do |file|
      files << file if file =~ regex
    end
    files
  end
  
  # Remove empty parent directories recursively
  def rm_empty_dirs( dir )
    if ( Dir.entries( dir ) - %w{ . .. .DS_Store } ).empty?
      FileUtils.rm_rf( dir )
      rm_empty_dirs( File.dirname( dir ) )
    end
  end
  
  # Create rdf at SPARQL endpoint
  def rdf( method, endpoint, url, file )
    throw "method parameter cannot be nil" if method == nil
    sparql = JackRDF.new( endpoint )
    case method.upcase
    when "PUT"
      sparql.put( url, file )
    when "POST"
      sparql.post( url, file )
    when "DELETE"
      sparql.delete( url )
    end
  end
  
  private_class_method :new
  
end