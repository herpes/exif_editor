#!/usr/bin/ruby

require "rubygems"
require "exifr"
require "parsedate"

class Pict
  attr_reader :date
  @date

  # @param : filepath(写真データまでの絶対パス)
  def initialize(filepath)
    @date = EXIFR::JPEG::new(filepath).date_time_original
  end

  # 指定した時刻分，撮影時刻をずらす
  def change_create_date(second)
    @date += second
  end

  # EXIFRで取得した日付情報(Timeクラス)をexif形式に戻す
  # Wed Aug 29 18:46:02 +0900 2012
  # ↓
  # 2012:08:22 00:06:27
  # 時刻
  def convert_date_to_exif
    return @date.strftime("%Y:%m:%d %H:%M:%S")
  end
end



filedir = ARGV[0] # 写真のディレクトリ
second = ARGV[1].to_i # ずらす時刻(秒)
Dir::glob(filedir + "/*.JPG").each{ |filepath|
  pic = Pict.new(filepath)
  pic.change_create_date(second)
  date = pic.convert_date_to_exif
  # ex. exiftool -datetimeoriginal="2012:08:30 10:10:10" ~/Desktop/test/IMG_1414.JPG 
  system("exiftool -datetimeoriginal=\"#{date}\" #{filepath}")
}
