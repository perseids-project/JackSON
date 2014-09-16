require 'pathname'
class JackHELP
  
  @@run = JackHELP.new
  
  def self.run
    return @@run
  end
  
  # Build the local path to a JSON file from a url
  def json_file( path, url )
    if url[-5..-1] != '.json'
      url = "#{url}.json"
    end
    url = Pathname.new( url ).cleanpath.to_s
    File.join( path, url )
  end
  
  # Write the JSON file
  def write_json( data, file )
    File.open( file, "w+" ) do |f|
      f.write( data )
    end
  end
  
  # Remove empty parent directories recursively.
  def rm_empty_dirs( dir )
    if ( Dir.entries( dir ) - %w{ . .. .DS_Store } ).empty?
      FileUtils.rm_rf( dir )
      rm_empty_dirs( File.dirname( dir ) )
    end
  end
  
  private_class_method :new
  
end