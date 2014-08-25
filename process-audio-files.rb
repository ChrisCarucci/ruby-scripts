#!/usr/bin/env ruby

=begin
This is a script that automatically converts a directory of WAV files and tags them appropriately based on the filename. This is used for categorizing market research calls.
=end

require 'optparse'

class Recording
  def initialize(source_path)
    @file_name = File.basename(source_path)
    parts = @file_name.split(' - ')
    @source_path = source_path
    @type = parts.first
    @year = File.ctime(source_path).to_s.split('-').first
    @description = parts.last.chomp(".WAV")
    @converted = false
  end

  def convert
    title = (@type == "ZTL") ? "Market Research - " + @description : "ISD Session - " + @description
    album = (@type == "ZTL") ? "Zero To Launch" : "Invisible Script Demolishers"
    lame_command = "lame -V6 --tt '#{title}' --ta 'Jarrett Coggin' --tl '#{album}' --ty '#{@year}' #{@source_path.gsub(' ', '\ ')}"
    puts lame_command
    `#{lame_command}`
    @converted = true
  end

  def move(destination)
    if @converted
      FileUtils.mv @source_path.gsub('WAV','mp3').gsub(' ', '\ ') destination+@file_name.gsub('WAV','mp3').gsub(' ', '\ ')
    end
  end
end

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
    recording = Recording.new(file)
    recording.convert
  end
end
