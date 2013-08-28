=begin
  usage: ruby extconf.rb [options ...]
  configure options:
    --with-opt-dir=/path/to/libraries
    --with-jpeg-include=dir
    --with-jpeg-lib=dir
    --with-png-include=dir
    --with-png-lib=dir
    --with-tiff-include=dir
    --with-tiff-lib=dir
=end
require 'mkmf'
require 'rbconfig'


if RUBY_PLATFORM =~ /darwin/
  search_dirs = ["/sw", "/usr/local", "/opt/local"]
  config_dirs = search_dirs.dup.delete_if { |path| !File.directory?(path) }
  raise "Could not find any of #{search_dirs.join(", ")}. Do you have native library dependencies installed?" if config_dirs.empty?

  dir_config('jpeg', config_dirs)
  dir_config('png', config_dirs)
  dir_config('tiff', config_dirs)
else
  $libs = append_library($libs, "supc++")
  dir_config('jpeg')
  dir_config('png')
  dir_config('tiff')
end

if have_header('jpeglib.h') && have_library('jpeg')
  $CPPFLAGS += ' -DUSE_JPG'
end

if have_header('png.h') && have_library('png')
  $CPPFLAGS += ' -DUSE_PNG'
end

if have_header('tiff.h') && have_library('tiff')
  $CPPFLAGS += ' -DUSE_TIFF'
end
create_makefile('rqr/QR')
