require 'helper'


class TestPhoto < Test::Unit::TestCase
  context "intialize" do
    setup do
      @photo = Photo.new(SAMPLE_PHOTO_PATH)
      @version = Version.new(SAMPLE_FILENAME, @photo)
    end

    
    should "create a new version object" do
      assert_instance_of(Aperture::Version, @version)
    end
    
    should "have a photo with a path" do
      assert File.directory?(@version.photo.path)
    end
    
    should "have nil for attributes" do
      assert @version.attributes.nil?
    end
    
    
  end
  
  context "parse" do
    setup do
      @photo = Photo.new(SAMPLE_PHOTO_PATH)
      @version = Version.new(SAMPLE_FILENAME, @photo)
      @version.parse
    end

    should "use plist gem and make hash" do
      assert_instance_of(Hash, @version.attributes)
    end
    
    should "pick out the right uuid for the version" do
      assert_equal @version.attributes['uuid'], 'nrS1aAXpRh2391GcraU5lw'
    end
    
    should "build a hash for EXIF Properties" do
      assert_instance_of(Hash, @version.attributes['exifProperties'])
    end
  end
  
  
  

end
