#!/usr/bin/env ruby

require 'fileutils'
require 'rmagick'

input_path = ARGV[0]
exit 1 unless input_path

FileUtils.cp(input_path, input_path + ".bak")

image = Magick::ImageList.new(input_path).first
pixels = image.get_pixels(0, 0, image.columns, image.rows)

crop_top = 0
crop_bottom = 0

(0...image.rows).each do |row|
  break unless (0...image.columns).all? { |column| pixels[image.columns * row + column].alpha < 0.0001 }
  crop_top = row
end


(0...image.rows).to_a.reverse.each.with_index do |row, i|
  break unless (0...image.columns).all? { |column| pixels[image.columns * row + column].alpha < 0.0001 }
  crop_bottom = i
end

image.crop!(0, crop_top, image.columns, image.rows - crop_top - crop_bottom, true)
image.write(input_path + ".tmp.png")

system("zopflipng", "-my", input_path + ".tmp.png", input_path)
