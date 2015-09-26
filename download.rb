#!/usr/bin/env ruby
require 'mechanize'
require 'fileutils'
require 'logger'


url = ARGV[0]
base_directory = ARGV[1] || nil

@base_directory = base_directory || './'
@agent = Mechanize.new
@agent.user_agent_alias = 'Mac Safari'
@agent.log = Logger.new "scrap.log"


def get_title(title)
  title.split('/').last.to_s.sub(' (music.com.bd)', '')
end

def get_directory(title)
  title.split(' - ')[0]
end

def save_music(link)
  unless !!link
    return false
  end
  directory = @page_title
  file = get_title(link)

  unless file
    return
  end

  full_dir = "#{@base_directory}/#{directory}"

  FileUtils.mkdir_p(full_dir)

  music = @agent.get(link)
  File.open("#{full_dir}/#{file}", 'wb') { |f| f << music.body }
end

def parse_page(page_link)
  content = @agent.get(page_link)
  music_link = content.search("a.btn-dl")[0]['href'].to_s.strip

  puts "Saving #{music_link}"
  save_music(music_link)
end

page = @agent.get(url)

@page_title = page.title.to_s.split(' > ')[2]
music_links = page.links_with(class: 'list-group-item')

threads = []
music_links.each_with_index do |link, idx|
  unless link.href.to_s.end_with? '.mp3.html'
    next
  end

  threads << Thread.new do
    parse_page(link.href)
  end
end

threads.each(&:join)
