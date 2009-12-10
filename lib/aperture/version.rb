
module Aperture
    class Version
    attr_accessor :filename, :photo, :attributes
    
    
    def initialize(filename, photo)
      @filename = filename
      @photo = photo
    end
    
    def parse
      @attributes = Plist::parse_xml( File.join(photo.path, @filename) )
    end
    
  end
end