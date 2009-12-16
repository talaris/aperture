# = Overview
# To use this libray check the Aperture::Library documentation and Library#parse
module Aperture
  VERSION = "0.2.0"
end


begin
  require 'plist'
rescue LoadError
  require 'rubygems'
  require 'plist'
end

require 'aperture/library'
require 'aperture/version'
require 'aperture/photo'
require 'aperture/photo_set'
require 'aperture/album'
require 'aperture/project'