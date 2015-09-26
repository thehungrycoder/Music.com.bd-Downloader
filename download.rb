#!/usr/bin/env ruby
require 'mechanize'
require 'fileutils'

url = ARGV[0]
base_directory = ARGV[1] || nil

@base_directory = base_directory || './'
@agent = Mechanize.new

def get_title(title)
  title.split(' - ')[1].to_s.sub(' (music.com.bd)','')
end

def get_directory(title)
  title.split(' - ')[0]
end


def save_music(title, link)
  unless !!link
    return false
  end
  directory = get_directory(title)
  file = get_title(title)

  music = @agent.get(link)

  full_dir = "#{@base_directory}/#{directory}"
  FileUtils.mkdir_p(full_dir)
  File.open("#{full_dir}/#{file}", 'wb'){ |f| f << music.body }
end

page = @agent.get(url)

music_links = page.links_with(class: 'list-group-item')
music_links.each_with_index do |link, idx|
  if idx == 0
    next #it's a link to previous page
  end
  content = @agent.get(link.href)
  music_link = content.search("a.btn-dl")[0]['href'].to_s.strip

  title = music_link.split('/').last

  puts "Saving #{music_link}"
  save_music(title, music_link)

end
