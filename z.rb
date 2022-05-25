#!/usr/bin/env ruby

require 'fileutils'
require 'rmagick'

input_path = ARGV[0]
exit 1 unless input_path

FileUtils.cp(input_path, input_path + ".tmp.png")
system("zopflipng", "-my", input_path + ".tmp.png", input_path)
