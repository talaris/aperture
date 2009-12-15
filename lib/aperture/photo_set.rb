
module Aperture
  class PhotoSet
    include Enumerable
    attr_accessor :photos
    
    def initialize(photos = {})
      @photos = photos
    end
    
    def <<(photo)
      @photos[ photo.master_attributes['uuid'] ] = photo
    end
    
    def each &blk
      @photos.values.each &blk
    end
        
    def method_missing(sym, *args, &block)
      @photos.send(sym, *args, &block) if @photos.respond_to?(sym)
    end
    


    def photo_count
      return @photos.size
    end
    
    def version_count
      return @photos.values.inject(0) {|sum, photo| sum += photo.versions.size}      
    end
    
    def camera_model_count_hash
      hash = Hash.new(0)
      self.each do |photo|
        model = photo.version(1).attributes['exifProperties']['Model']
        hash[model] += 1
      end

      return hash
    end
    
    def lens_model_count_hash
      hash = Hash.new(0)
      self.each do |photo|
        model = photo.version(1).attributes['exifProperties']['LensModel']
        hash[model] += 1
      end

      return hash
    end
    
    # def find_photos_by_keyword
    
    # def find_photos_by_rating
      
  end
end
