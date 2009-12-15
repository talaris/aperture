
module Aperture
    class Version
    attr_accessor :photo, :attributes, :filename
    
    
    def initialize(filename, attributes, photo)
      @attributes = attributes
      @filename   = filename
      @photo      = photo
    end
  end
end