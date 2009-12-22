require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "aperture"
    gem.summary = %Q{Statistical analysis library for Aperture Photo Libraries}
    gem.description = %Q{Parses out the files from a Aperture Photo Library to give useful figures and check consistancy of the Library itself.}
    gem.email = "kyle.burckhard@gmail.com"
    gem.homepage = "http://github.com/talaris/aperture"
    gem.authors = ["Kyle Burckhard"]
    gem.add_development_dependency "shoulda", ">= 2.10.0"
    gem.add_dependency('plist', '>= 3.0.0')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'fileutils'
require 'find'
namespace "library" do
  desc "Copies key directories and metadata files from an Aperture library into 'test/data'. Defaults to cloning your entire Aperture Library."
  task :clone, [:library_path, :test_path] do |t, args|
    args.with_defaults(
      :library_path => File.join(ENV['HOME'], 'Pictures', 'Aperture Library.aplibrary'), 
      :test_path => File.join(File.dirname(__FILE__), 'test', 'data')
      )
    library_path, test_path = args[:library_path], args[:test_path]

    raise ArgumentError, "Requires valid directory path" unless File.directory?(library_path)
    FileUtils.mkdir_p(test_path)
    
    
    Find.find(library_path) do |path|
      clone_path = File.join(test_path, path.partition(library_path)[2])
      Find.prune if path =~ /Thumbnails|Previews/
      FileUtils.mkdir_p(clone_path) if File.directory?(path)
      if path =~  /\.apfolder|\.implicitAlbum|\.apsmartalbum|\.apmaster|\.apversion|\.apfile|\.apalbum/
        FileUtils.cp(path, clone_path)
      end
    end
      
  end
end