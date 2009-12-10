$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'aperture'
include Aperture


SAMPLE_LIBRARY_PATH = File.join(File.dirname(__FILE__), 'data')
SAMPLE_PHOTO_PATH = File.join(File.dirname(__FILE__),
    'data', '2009-07-08 @ 09:35:47 AM - 1.apimportgroup', 'IMG_1753')
SAMPLE_FILENAME = 'OriginalVersionInfo.apversion'
SAMPLE_ORIGINAL_FILENAME = 'OriginalVersionInfo.apversion'
SAMPLE_VERSION_FILENAME = 'Version-1.apversion'
 
class Test::Unit::TestCase
end