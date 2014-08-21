#!/usr/bin/env ruby

=begin
This is a script that automatically converts a directory of WAV files and tags them appropriately based on the filename. This is used for categorizing market research calls.
=end

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: process-audio-files.rb -s foldername"
  opts.on('-s', '--sourcedir DIRECTORY', 'Directory Name') { |v| options[:source_directory] = v }
end.parse!

folder = options[:source_directory]
if folder != nil
  # Get all WAV files in the directory.
  files = Dir[folder + "*.WAV"]

  #Process each file in the directory, pulling out the filename and using that to define where the file will go and what parameters to pass to LAME.
  files.each do |file|
    filename = File.basename(file)
    parts = filename.split('-')
    type = parts[0]
    # TODO: add in date extraction and description extraction.
  end
end
