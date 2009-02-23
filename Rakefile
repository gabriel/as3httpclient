require 'rubygems'
require 'airake'

project_root = File.expand_path(File.dirname(__FILE__))

ENV["AIRAKE_ROOT"] ||= project_root
ENV["AIRAKE_ENV"] ||= "development"

task :default => :compile do; end

# For task list run, rake --tasks
task :test => [ "air:test" ] do; end 
task :compile => [ "air:compile" ] do; end 
task :package => [ "air:package" ] do; end 
task :adl => [ "air:adl" ] do; end 
task :docs => [ "air:docs" ] do; end 
task :clean => [ "air:clean" ] do; end 
task :acompc => [ "air:acompc" ] do; end 

task :flash_swf do

  cmd = "mxmlc +configname=flex -source-path #{project_root}/src -library-path+=#{project_root}/lib \
-output #{project_root}/html/HttpClientFlashApp.swf -- #{project_root}/src/org/httpclient/ui/HttpClientApp.mxml"

  puts "Command: #{cmd}"
  system(cmd)
  
end