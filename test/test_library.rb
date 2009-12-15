require 'helper'

class TestLibrary < Test::Unit::TestCase
  context "#initialize" do
    setup do
      @library = Library.new(SAMPLE_LIBRARY_PATH)
    end
    
    should "create require a path" do
      assert_raise ArgumentError do
        Aperture::Library.new()
      end
    end
    
    should "required path should be a directory" do
      assert_raise ArgumentError do
        Aperture::Library.new('root')
      end
    end
    
    should "create a new library object" do
      assert_instance_of(Aperture::Library, @library)
    end
    
    should "photos should be a photoset" do
      assert_instance_of(Aperture::PhotoSet, @library.photos)
    end
    
    should "albums should be a empty hash" do
      assert_instance_of(Hash, @library.albums)
      assert @library.albums.empty?
    end  
    
    should "projects should be a empty hash" do
      assert_instance_of(Hash, @library.projects)
      assert @library.albums.empty?
    end
      
    should "versions should be a empty hash" do
      assert_instance_of(Hash, @library.versions)
      assert @library.albums.empty?
    end
    
    should "set root is a directory" do
      assert File.directory?(@library.root)
    end
    
    should "set photos to an empty array" do
      assert_equal @library.photos.size, 0
    end
  end
  
  context "parsed library" do
    setup do
      @library = SAMPLE_LIBRARY
    end

    should "find 24 photos" do
      assert_equal @library.photos.size, 24
    end
    
    should "find 2 albums" do
      assert_equal @library.albums.size, 2
    end
      
    should "find 5 projects" do
      assert_equal @library.projects.size, 5
    end
    
    should "find 5 versions" do
      assert_equal @library.versions.size, 34
    end
    
    should "find 1 versions in IMG_1753" do
      photo = @library.photos[SAMPLE_PHOTO_UUID]
      assert_equal photo.versions.size, 1
    end
    
    should "find 11 version of 2008-Costume Contest" do
      photo = @library.photos['wNOJs+P3RTOwER5t4jDmog']
      assert_equal photo.versions.size, 11
    end
  end
  
end
