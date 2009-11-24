
module Aperture
    class Photo
    attr_reader :versions, :path
    def initialize(path)
      @path = path
      @verisions = []
    end
    
    def <<(version)
      @versions << version
    end
    
    def each
      
    end
    
  end
end