require 'find'

module Aperture
  class Library
    attr_reader :root, :photos, :albums, :projects, :versions
    
    def initialize(root)
      raise ArgumentError, "Requires valid directory path" unless File.directory?(root)
      @root = root 
      @photos = Aperture::PhotoSet.new
      @albums = []
      @projects = []
      @versions = {}
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
        photo = library.add_photo(File.dirname(path))
        photo.master_attributes = Plist::parse_xml(path)
      end
      
      # Photo Files
      files.select {|p| p =~ /\.apfile$/}.each do |path|
        photo = library.find_photo_by_path(File.dirname(path))
        photo.file_attributes = Plist::parse_xml(path)
      end
            
      # Versions
      files.select {|p| p =~ /Version-.+\.apversion$/}.each do |path|
        directory, filename = File.dirname(path), File.basename(path)
        
        photo =  library.find_photo_by_path(directory)
        attributes = Plist::parse_xml(path)
        version = Version.new(filename, attributes, photo)
        photo.versions << version
        library.versions[version.attributes['uuid']] = version
      end
      
      # Albums
      files.select {|p| p =~ /\.apalbum/ }.each do |path|
        attributes = Plist::parse_xml(path)
        attributes['directory'] = File.dirname(path)
        attributes['filename'] = File.basename(path)
        album = Album.new(attributes)
        
        library.albums << album
        
        if version_ids = album.attributes['InfoDictionary'] && album.attributes['InfoDictionary']['versionUuids'] 
          album.photos = version_ids.
            map {|id| library.versions[id]}.
            map {|v| v.photo}.
            uniq
          
          version_ids.each do |id|
            library.versions[id].photo.albums << album unless library.versions[id].photo.albums.include?(album)
          end 
        end
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