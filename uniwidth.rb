#!/usr/bin/ruby

require 'fileutils'

if ARGV.size <= 2 then
  puts "Usage: uniwidth.rb target_width output_dir file1 file2 file3 ..."
  exit
end

outWidth = ARGV[0].to_i
outDir = ARGV[1]

FileUtils.mkdir_p(outDir) unless FileTest.exist?(outDir)

ARGV.drop(2).each { |image|
  width =  `identify -format "%w" #{image}`.to_i
  height = `identify -format "%h" #{image}`.to_i

  diff = outWidth - width
  space = diff / 2
  output = "#{outDir}/#{File.basename(image)}"

  if diff > 0 then
    `convert #{image} -bordercolor none -border #{space}x0 #{output}`
  elsif diff < 0 then
    `convert -crop #{outWidth}x#{height}+#{-space}+0 #{image} #{output}`
  else
    `cp #{image} #{output}`
  end
}