require 'find'

module Aperture
  class Library
    attr_reader :root, :photos, :albums, :projects
    
    def initialize(root)
      raise ArgumentError, "Requires valid directory path" unless File.directory?(root)
      @root = root 
      @photos = Aperture::PhotoSet.new
      @albums = []
      @projects = []
    end    
    
    def self.parse(root_path)
      library = new(root_path)
      files = []  
      Find.find(library.root) do |path|
        files << path
      end
      
      # Projects
      files.select {|p| p =~ /\.approject$/ }.each do |path|
        project = Project.new
        project.attributes = Plist::parse_xml(File.join(path, 'Info.apfolder'))
        library.projects << project
      end
      
      # Photo Masters
      files.select {|p| p =~ /Info\.apmaster$/}.each do |path|
        directory = File.dirname(path)
        photo = library.add_photo(directory)
        photo.master_attributes = Plist::parse_xml(path)
      end
      
      # Photo Files
      files.select {|p| p =~ /\.apfile$/}.each do |path|
        directory = File.dirname(path)
        photo = library.find_photo_by_path(directory)
        photo.file_attributes = Plist::parse_xml(path)
      end
            
      # Versions
      files.select {|p| p =~ /Version-.+\.apversion$/}.each do |path|
        directory, filename = File.dirname(path), File.basename(path)
        
        photo =  library.find_photo_by_path(directory)
        attributes = Plist::parse_xml(path)
        photo.versions << Version.new(filename, attributes, photo)
      end
      
      # Albums
      files.select {|p| p =~ /\.apalbum/ }.each do |path|
        # directory, filename = File.dirname(path), File.basename(path)
        attributes = Plist::parse_xml( path)
        attributes['directory'] = File.dirname(path)
        attributes['filename'] = File.basename(path)
        album = Album.new(attributes)
        
        library.albums << album
      end
      
      return library
    end
    
    def find_photo_by_path(path)
      return @photos.select {|p| p.path == path}.first
    end
    
    def add_photo(directory)  
      photo = Photo.new(directory)
      @photos << photo
      return photo
    end
  end
end