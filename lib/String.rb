class String
  
  
  # Check to see if we're looking at an integer in string's clothing
  
  def is_i?
     !!( self =~ /\A[-+]?[0-9]+\z/ )
  end
  
  
  # Turn delimiters into colons
  # c { String } The character to change
  
  def colonize( c )
    self.gsub!( c, ':' ) || self
  end
  
  
  # Turn a URN into a path
  
  def urn_to_path()
    this = self.detagify
    this.gsub!( /:|\./, '/' ) || out
  end
  
  
  # Return only integers
  
  def just_i
    /\d+/.match( self ).to_s.to_i
  end
  
  
  # Quote a string
  
  def quote( c='"' )
    this = self
    if this[0] != '"' && this[0] != "'"
      this = "#{c}#{this}"
    end
    if this[-1,1] != '"' && this[-1,1] != "'"
      this = "#{this}#{c}"
    end
    this
  end
  
  
  # Dequote a string
  
  def dequote
    this = self
    if this[0] == '"' || this[0] == "'"
      this[0] = ''
    end
    if this[-1,1] == '"' || this[-1,1] == "'"
      this[-1,1] = ''
    end
    this
  end
  
  
  # Wrap <>
  
  def tag
    this = self
    if this[0] != "<"
      this = "<#{this}"
    end
    if this[-1,1] != ">"
      this = "#{this}>"
    end
    this
  end
  
  
  # Unwrap <>
  
  def detag
    this = self
    if this[0] == "<"
      this = this[1..-1]
    end
    if this[-1,1] == ">"
      this = this[0..-2]
    end
    this
  end
  
end