#!/usr/bin/ruby

require 'fileutils'

if ARGV.size <= 2 then
  puts "Usage: uniheight.rb target_height output_dir file1 file2 file3 ..."
  exit
end

outHeight = ARGV[0].to_i
outDir = ARGV[1]

FileUtils.mkdir_p(outDir) unless FileTest.exist?(outDir)

ARGV.drop(2).each { |image|
  width =  `identify -format "%w" #{image}`.to_i
  height = `identify -format "%h" #{image}`.to_i

  diff = outHeight - height
  space = diff / 2
  output = "#{outDir}/#{File.basename(image)}"

  if diff > 0 then
    `convert #{image} -bordercolor none -border 0x#{space} #{output}`
  elsif diff < 0 then
    `convert -crop #{width}x#{outHeight}+0+#{-space} #{image} #{output}`
  else
    `cp #{image} #{output}`
  end
}