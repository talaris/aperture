
module Aperture
  # = Overview
  # The Version object matches up with Version entries from an Aperture Library. Version 
  # objects are linked an Aperture::Photo
  class Version
    attr_accessor :photo, :attributes, :filename
    
    # Creates a new Version object given the following required arugments:
    # * the filename for the .apversion file as found on the disk
    # * a hash of attributes, this should be the hash returned from parsing the .apversion 
    #   file by the plist gem.
    # * the Photo object that the version is associated with
    def initialize(filename, attributes, photo)
      @attributes = attributes
      @filename   = filename
      @photo      = photo
    end
  end
end