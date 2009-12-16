
module Aperture
  
  # = Overview
  # The Album object matches up with Album entries from an Aperture Library. Albums cotain
  # Aperture::Photo objects through an Aperture::PhotoSet.
  class Album
    attr_accessor :photos, :attributes
    
    # Creates a new Album object given a hash of attributes, this should be the hash returned
    # from parsing the .apablum file by the plist gem.
    def initialize(attributes)
      @attributes = attributes
      @photos = PhotoSet.new
    end
  end
end