require 'helper'

class TestPhotoSet < Test::Unit::TestCase
  context "#initialize" do
    setup do
      @photoset = PhotoSet.new()
    end
    
    should "create a new photo_set object" do
      assert_instance_of(Aperture::PhotoSet, @photoset)
    end
    
    should "set photos attribute to an empty array" do
      assert_equal @photoset.photos, []
    end
  end
  
  context "<<" do
    setup do
      @photoset = PhotoSet.new()
      @photo = Photo.new(SAMPLE_PHOTO_PATH)
    end

    should "adding an photo should increase the size by 1" do
      @photoset << @photo
      assert_equal @photoset.photos.size, 1
    end
  end
  
  # context "each" do
  #   setup do
  #     @photoset = PhotoSet.new()
  #     @photo = Photo.new(SAMPLE_PHOTO_PATH)
  #   end
  # 
  #   should "iterate over all the photos" do
  #     versions = 0
  #     @photoset.each {|p| versions += p.versions.size}
  #     assert_equal versions, 12
  #   end
  #   
  #   should "give us access to inject" do
  #     versions = @photoset.map {|p| p.versions.size }
  #     assert_equal versions, [2]*6
  #   end
  # end
  
  context "photo_count" do
    setup do
      @library = SAMPLE_LIBRARY
    end

    should "should return all 24 photos" do
      assert_equal @library.photos.photo_count, 24
    end
  end
  
  context "version_count" do
    setup do
      @library = SAMPLE_LIBRARY
    end

    should "should return all 34 versions" do
      assert_equal @library.photos.version_count, 34
    end
  end
  
  context "camera_model_count_hash" do
    setup do
      @library = SAMPLE_LIBRARY
    end

    should "Find 6 photos from 'Canon PowerShot SD770 IS'" do
      camera_model = 'Canon PowerShot SD770 IS'
      assert_equal @library.photos.camera_model_count_hash[camera_model], 12
    end
  end
  
  context "lens_model_count_hash" do
    setup do
      @library = SAMPLE_LIBRARY
    end

    should "Find 6 photos from lens '6.2-18.6 mm'" do
      lens_model = '6.2-18.6 mm'
      assert_equal @library.photos.lens_model_count_hash[lens_model], 12
    end
  end
  
end