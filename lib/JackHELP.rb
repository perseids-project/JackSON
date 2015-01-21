require 'pathname'
require 'JackRDF'
require 'yaml'

class JackHELP
  
  # Get settings
  
  @@settings = YAML.load( File.read("#{File.dirname(__FILE__)}/../JackSON.config.yml") )
  def self.settings
    @@settings
  end
  
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
  
  
  # Create RDF at SPARQL endpoint
  
  def rdf( method, endpoint, url, file, onto )
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
  
  
  # Destroy all data
  
  def destroy_data
    destroy_json()
    destroy_triples()
  end
  
  
  # Destroy all JSON
  
  def destroy_json
    FileUtils.rm_rf( @@settings["path"] )
    FileUtils.mkdir( @@settings["path"] )
  end
  
  
  # Destroy all Fuseki triples
  
  def destroy_triples
    quick = SparqlQuick.new( @@settings["sparql"] )
    quick.empty( :all )
  end
  
  private_class_method :new
  
end