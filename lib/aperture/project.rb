
module Aperture
  # = Overview
  # The Project object matches up with Projects entries from an Aperture Library. Projects cotain
  # Aperture::Photo objects through an Aperture::PhotoSet.
  class Project
    attr_accessor :photos, :attributes
    
    # Creates a new Project object given a hash of attributes, this should be the hash returned
    # from parsing the .approject/Info.apfolder file by the plist gem.
    def initialize(attributes = {})
      @attributes = attributes
      @photos = PhotoSet.new
    end
  end
end