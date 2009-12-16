
module Aperture

  # = Overview
  # The PhotoSet object that contains a series of Photo objects in a hash. This object is used
  # by the Library, Album and Project objects cotain photos. This object also contains methods
  # to look up interest statistics across the set.
  #
  # = Statistic gathering methods
  # * photo_count - number of photos in set
  # * version_count - number of versions across all photos in set
  # * camera_model_count_hash - count of how many times each camera used in the set
  # * lens_model_count_hash - count of how many times each lens used in the set
  #
  # *Note* This object can be directly treated like an array using each or any method from 
  # the Enumerable module. These will access the the values, the Photo objects, contained 
  # within the hash.
  class PhotoSet
    include Enumerable
    attr_accessor :photos
    
    # Creates a new PhotoSet, can be passed an array of Photo objects
    def initialize(photos = {})
      @photos = photos
    end
    
    # Adds a Photo to the hash PhotoSet uses to track Photo's using the photo's UUID. This UUID
    # matches up to the masterUuid found in Version#attributes
    def <<(photo)
      @photos[ photo.master_attributes['uuid'] ] = photo
    end
    
    # Iterates over the hash's values, ie the photos, the PhotoSet is tracking 
    def each &blk
      @photos.values.each &blk
    end
    
    # This method passes any unknown method calls onto the hash of photos, allowing you to 
    # treat the PhotoSet object as the Hash of photos it holds.
    def method_missing(sym, *args, &block)
      @photos.send(sym, *args, &block) if @photos.respond_to?(sym)
    end
    

    # Returns the number of photos tracked by the PhotoSet 
    def photo_count
      return size
    end
    
    # Returns the number of versions across all the photos tracked by the PhotoSet
    def version_count
      return inject(0) {|sum, photo| sum += photo.versions.size}      
    end
    
    # Returns a hash in the following format
    # * The keys are the camera model for the photo parsed from the EXIF information
    # * The value is the number of times that camera model shows up across all the photos in 
    #   the set
    def camera_model_count_hash
      hash = Hash.new(0)
      self.each do |photo|
        model = photo.version(1).attributes['exifProperties']['Model']
        hash[model] += 1
      end

      return hash
    end
    
    # Returns a hash in the following format
    # * The keys are the lens model for the photo parsed from the EXIF information
    # * The value is the number of times that lens model shows up across all the photos in 
    #   the set    
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
