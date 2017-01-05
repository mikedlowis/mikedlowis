#!/usr/bin/ruby
require 'open-uri'
require 'nokogiri'
require 'erb'

def trim(str)
  str.sub(/^[\t\n ]*/, "").sub(/[\t\n ]*$/, "")
end

def user_repos(user)
  url = "https://github.com/#{user}?tab=repositories"
  sel = 'div[class=js-repo-list] li[class~=source]'
  items = Nokogiri::HTML(open(url)).css(sel).map do |e|
    reponame = trim(e.css('div h3 a').text)
    { name: reponame, 
      desc: trim(e.css('div p').text),
      url:  "https://github.com/#{user}/#{reponame}" }
  end
end

def org_repos(org)
  url = "https://github.com/#{org}"
  sel = 'div[class~=repo-list] li[class~=source]'
  items = Nokogiri::HTML(open(url)).css(sel).map do |e|
    reponame = trim(e.css('div h3 a').text)
    { name: reponame, 
      desc: trim(e.css('div p').text),
      url:  "https://github.com/#{org}/#{reponame}" }
  end
end

#------------------------------------------------------------------------------

class Page
  include ERB::Util
  attr_accessor :title, :menuid, :contents
  
  def initialize(page)
    match = page.match(/(\d+)-(.+).md/)
    @title = match[2].capitalize
    @menuid = match[1]
    @contents = `tools/md2html.awk #{page}`
  end

  def render()
    ERB.new(IO.read("templates/page.erb")).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
  
  def getmenu()
    menu = "<span class='left'>\n"
    Dir.glob('pages/*.md').each_with_index do |e,idx|
        page = e.match(/\d+-(.+).md/)[1]
        menu += "<a id='menuitem#{idx}' href='#{page}.html'>#{page}</a>\n" 
    end
    menu += "</span>\n"
    menu
  end
end

#------------------------------------------------------------------------------

File.open("pages/2-projects.md", "w") do |f|
  f.puts "# Projects\n\n"
  user_repos('mikedlowis').each do |e|
    f.puts "* [#{e[:name]}](#{e[:url]}) - #{e[:desc]}"
  end
end

File.open("pages/3-prototypes.md", "w") do |f|
  f.puts "# Prototypes\n\n"
  org_repos('mikedlowis-prototypes').each do |e|
    f.puts "* [#{e[:name]}](#{e[:url]}) - #{e[:desc]}"
  end
end

Dir.glob('pages/*.md').each do |md|
  html = "site/" + md.match(/\d+-(.+).md/)[1] + ".html"
  puts "#{md} -> #{html}"
  Page.new(md).save(html)
end

# Generate Home Page
# Generate Articles Page
# Generate Projects Page
# Generate Prototypes Page