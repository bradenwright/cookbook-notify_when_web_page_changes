#
# Cookbook Name:: notify_when_web_page_changes
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'mailutils'


include_recipe 'rbenv'
include_recipe 'rbenv::ruby_build'
include_recipe 'rbenv::rbenv_vars'

# find all versions of ruby 2.x avail 
ENV['ruby_major_version'] = '2'
ruby_version = `benv install --list | egrep -o "\s${ruby_major_version}(\.[0-9]*){2}$" | sort -r  | awk '{print $1}' | head -1`.chomp
ruby_version = '2.3.1' if (!$?.to_i == 0 || ruby_version.empty?)

rbenv_ruby ruby_version do
  global true
end

%w{ googleauth google-api-client gmail-api-ruby rmail launchy }.each do |gem|
  rbenv_gem gem do
    ruby_version ruby_version
  end
end

template '/root/notify_when_web_page_changes.rb' do
  mode 750
  variables ruby_path: '/opt/rbenv/shims/ruby'
end
