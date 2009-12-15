require 'helper'


class TestAlbum < Test::Unit::TestCase
  context "intialize" do
    setup do
      @album = Album.new( Hash.new )
    end
    
    should "create a new album object" do
      assert_instance_of Aperture::Album, @album
    end
    
    should "pass a hash as valid attirbutes" do
      assert_instance_of Hash, @album.attributes
    end
  end
end