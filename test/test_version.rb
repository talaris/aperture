require 'helper'


class TestVersion < Test::Unit::TestCase
  context "intialize" do
    setup do
      @photo = Photo.new(SAMPLE_PHOTO_PATH)
      @version = Version.new(SAMPLE_FILENAME, {}, @photo)
    end

    
    should "create a new version object" do
      assert_instance_of(Aperture::Version, @version)
    end
    
    should "have a photo with a path" do
      assert File.directory?(@version.photo.path)
    end
    
    should "have hash for attributes" do
      assert_instance_of(Hash, @version.attributes)
    end
  end
  
  context "parsed version" do
    setup do 
      @version = SAMPLE_LIBRARY.photos[SAMPLE_PHOTO_UUID].version(1)
    end
    
    should "pick out the right uuid for the version" do
      assert_equal @version.attributes['uuid'], 'PryZQJZRSaqB0BdzD2AIAA'
    end
    
    should "build a hash for EXIF Properties" do
      assert_instance_of(Hash, @version.attributes['exifProperties'])
    end
  end
  
end
