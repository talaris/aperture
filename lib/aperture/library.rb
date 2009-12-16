require 'find'

module Aperture
  
  # = Overview
  # The Library object parses and organizes the collection of objects that make up an aperture 
  # photo library. From the object you can access information about the Versions, Photos, 
  # Albums and Projects contained in the Library.
  #
  # *Note* Depending on the size of the Aperture photo library parsing it into ruby objects 
  # may take serveral minutes.
  class Library
    attr_reader :root, :photos, :albums, :projects, :versions
    
    def initialize(root) # :nodoc:
      raise ArgumentError, "Requires valid directory path" unless File.directory?(root)
      @root = root 
      @photos = Aperture::PhotoSet.new
      @albums = {}
      @projects = {}
      @versions = {}
    end    
    
    # This the key method for parsing the library, it requires the path of where the library
    # exists on disk. It returns a fully parsed Library object. 
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
        library.projects[project.attributes['uuid']] = project
      end
      
      # Photo Masters
      files.select {|p| p =~ /Info\.apmaster$/}.each do |path|
        photo = Photo.new(File.dirname(path))
        photo.master_attributes = Plist::parse_xml(path)
        photo.master_attributes['path']
        library.photos << photo
      end
      
      # Photo Files
      files.select {|p| p =~ /\.apfile$/}.each do |path|
        file_attributes = Plist::parse_xml(path)
        library.photos[file_attributes['masterUuid']].file_attributes = file_attributes
      end
            
      # Versions
      files.select {|p| p =~ /Version-.+\.apversion$/}.each do |path|
        directory, filename = File.dirname(path), File.basename(path)
        attributes = Plist::parse_xml(path)

        # find associated photo
        photo =  library.photos[attributes['masterUuid']]
        
        # build version object
        version = Version.new(filename, attributes, photo)
                        
        # add version to photo
        photo.versions << version
        
        # add verion to library
        library.versions[version.attributes['uuid']] = version
        
        # add version's photo to project
        library.projects[version.attributes['projectUuid']].photos << version.photo
      end
      
      # Albums
      files.select {|p| p =~ /\.apalbum/ }.each do |path|
        attributes = Plist::parse_xml(path)
        attributes['directory'] = File.dirname(path)
        attributes['filename'] = File.basename(path)
        album = Album.new(attributes)
        
        library.albums[album.attributes['InfoDictionary']['uuid']] = album
        
        if version_ids = album.attributes['InfoDictionary'] && album.attributes['InfoDictionary']['versionUuids'] 
          version_ids.each do |id|
            album.photos[library.versions[id].attributes['masterUuid']] = library.versions[id].photo
            library.versions[id].photo.albums << album unless library.versions[id].photo.albums.include?(album)
          end 
        end
      end
      
      return library
    end
  end
end