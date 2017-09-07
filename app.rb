#!/usr/bin/env ruby
require 'bundler'
require 'pp'
Bundler.require
require 'json'

def request_github_api(method, path, payload=nil)
  response = Faraday.send(method, 'https://api.github.com' + path) do |req|
    req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
  end
  puts "#{method.upcase} #{path} => #{response.status}"
  # p response.body
  unless response.body.empty?
    JSON.parse(response.body)
  end
end

notifications = request_github_api(:get, '/notifications')
notifications.each do |notification|
  subject = notification['subject']
  puts "#{subject['type']}:#{subject['title']}"
  if subject['type'] == 'Release'
    puts request_github_api(:patch, "/notifications/threads/#{notification['id']}")
    # break
  end
end
