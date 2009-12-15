module Aperture
  VERSION = "0.1.0"
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