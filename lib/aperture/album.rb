
module Aperture
  class Album
    attr_accessor :photos, :attributes
    
    def initialize(attributes)
      @attributes = attributes
      @photos = PhotoSet.new
    end
    
    def photos=(photo_array)
      @photos = PhotoSet.new(photo_array)
    end
  end
end