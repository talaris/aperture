require 'rubygems'
require 'test/unit'
require 'shoulda'
 
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'aperture'


SAMPLE_LIBRARY_PATH = File.join(File.dirname(__FILE__), 'data', 'sample_library')
SAMPLE_PHOTO_PATH = path = File.join(File.dirname(__FILE__),
    'data', 'sample_library', '2009-07-08 @ 09:35:47 AM - 1.apimportgroup', 'IMG_1753')

 
class Test::Unit::TestCase
end