require 'find'

module Aperture
  class Library
    attr_reader :root, :photos
    
    def initialize(root)
      raise ArgumentError, "Requires valid directory path" unless File.directory?(root)
      @root = root 
      @photos = []
    end
    
    def index
      Find.find(root) do |path|
        if path =~ /\.apversion$/
          directory = File.dirname(path)
          filename = File.basename(path)
          
          photo =  find_photo_by_path(directory) || add_photo(directory)
          photo.versions << Version.new(filename, photo)
        end
      end
    end
    
    def parse_all
      @photos.each do |photo|
        photo.parse_all
      end        
    end
    
    def find_photo_by_path(path)
      return @photos.select {|p| p.path == path}.first
    end
    
    def add_photo(directory)  
      photo = Photo.new(directory)
      @photos << photo
      return photo
    end
    
    def photo_count
      return @photos.size
    end
    
    def version_count
      return @photos.inject(0) {|sum, photo| sum += photo.versions.size}      
    end
    
    def camera_model_count_hash
      hash = Hash.new(0)
      @photos.each do |photo|
        model = photo.original_version.attributes['exifProperties']['Model']
        hash[model] += 1
      end

      return hash
    end
    
    def lens_model_count_hash
      hash = Hash.new(0)
      @photos.each do |photo|
        model = photo.original_version.attributes['exifProperties']['LensModel']
        hash[model] += 1
      end

      return hash
    end
    
    
  end
end