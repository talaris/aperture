require 'find'
begin
  require 'progressbar'
rescue LoadError
end

module Aperture
  
  # = Overview
  # The Library object parses and organizes the collection of objects that make up an aperture 
  # photo library. From the object you can access information about the Versions, Photos, 
  # Albums and Projects contained in the Library.
  #
  # There is an optional second argument for parse the enable more verbose output.
  #
  # *Note:* Depending on the size of the Aperture photo library parsing it into ruby objects 
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
    # The second arugment makes the method give more verbose output while it is processing. 
    # Using the ProgressBar gem, to install use: <tt>[sudo] gem install ruby-progressbar</tt>
    #
    # http://github.com/nex3/ruby-progressbar
    def self.parse(root_path, verbose=false)
      library = new(root_path)
      pb = nil 
      files = []  
      
      if verbose
        print "Finding metadata files in library: "
        st = Time.now
      end
      
      Find.find(library.root) do |path|
        files << path
      end
      
      puts "#{(Time.now - st)} seconds" if verbose
      
      # Projects
      files_projects = files.select {|p| p =~ /\.approject$/ }
      # puts files_projects.size
      pb = ProgressBar.new("projects", files_projects.size) if defined?(ProgressBar) && verbose
      files_projects.each do |path|
        project = Project.new
        project.attributes = Plist::parse_xml(File.join(path, 'Info.apfolder'))
        library.projects[project.attributes['uuid']] = project
        pb.inc if pb
      end
      pb.finish if pb
      
      # Photo Masters
      files_masters = files.select {|p| p =~ /Info\.apmaster$/}
      # puts files_masters.size
      pb = ProgressBar.new("photo masters", files_masters.size) if defined?(ProgressBar) && verbose      
      files_masters.each do |path|
        photo = Photo.new(File.dirname(path))
        photo.master_attributes = Plist::parse_xml(path)
        photo.master_attributes['path']
        library.photos << photo
        pb.inc if pb
      end
      pb.finish if pb
      
      # Photo Files
      files_files = files.select {|p| p =~ /\.apfile$/}
      # puts files_files.size
      pb = ProgressBar.new("photo files", files_files.size) if defined?(ProgressBar) && verbose      
      files_files.each do |path|
        file_attributes = Plist::parse_xml(path)
        library.photos[file_attributes['masterUuid']].file_attributes = file_attributes
        pb.inc if pb
      end
      pb.finish if pb
            
      # Versions
      files_versions = files.select {|p| p =~ /Version-.+\.apversion$/}
      # puts files_versions.size
      pb = ProgressBar.new("versions", files_projects.size) if defined?(ProgressBar) && verbose      
      files_versions.each do |path|
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
        pb.inc if pb
      end
      pb.finish if pb
      
      # Albums
      files_albums = files.select {|p| p =~ /\.apalbum/ }
      # puts files_albums.size
      pb = ProgressBar.new("albums", files_albums.size) if defined?(ProgressBar) && verbose
      files_albums.each do |path|
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
        pb.inc if pb
      end
      pb.finish if pb
      
      return library
    end
  end
end