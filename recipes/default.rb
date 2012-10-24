#
# Cookbook Name:: ximdex
# Recipe:: default
#
# Copyright 2011, Besol Soluciones S.L.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


# Installs Apache, PHP and MySQL dependencies using existing recipes
%w(apache2::mod_php5
php php::module_mysql php::module_gd php::module_curl
mysql::server mysql::client).each do |recipe_dependency|
  include_recipe recipe_dependency
end

# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]

# Removed following packages considering they are installed by recipe dependencies: php5-curl, php5-gd, php5-mysql
%w(php5-xsl php5-cli  
php-pear php5-suhosin php-gettext 
ttf-dejavu-core libmcrypt4 libt1-5 
fontconfig-config libxpm4 libgd2-xpm 
php5-mcrypt libjpeg62).each do |package_dependency|
  package package_dependency
end

directory node['ximdex']['params_path'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "Download ximdex tarball" do
  code "wget http://www.ximdex.org/resources/download/ximdex_3.3_open_r8411.tar.gz"
  user 'root'
  creates "#{node['ximdex']['params_path']}/ximdex_3.3_open_r8411.tar.gz"
  cwd node['ximdex']['params_path']
end

bash "Untar ximdex tarball" do
  code "tar zxvf ximdex_3.3_open_r8411.tar.gz && mv ximdex/* ."
  user 'root'
  cwd node['ximdex']['params_path']
  only_if "test -f \"#{node['ximdex']['params_path']}/ximdex_3.3_open_r8411.tar.gz\""
end

bash "Clean up after ximdex tarball extraction" do
  code "rmdir ximdex/ && rm -rf ximdex_3.3_open_r8411.tar.gz"
  user 'root'
  cwd node['ximdex']['params_path']
end

template "#{node['ximdex']['params_path']}/install/templates/setup.conf" do
  source "setup.conf.erb"
  owner "root"
  group "root"
  mode "0600"
end

bash "Install ximdex" do
  code "./install/install.sh -a"
  user 'root'
  cwd node['ximdex']['params_path']
end

bash "Set www-data permissions for ximdex install" do
  code "chown -R www-data:www-data *"
  user 'root'
  cwd node['ximdex']['params_path']
end

if node['ximdex']['params_path'] == '/var/www'
  bash "Remove apache default index.html" do
    code "rm -f index.html"
    user 'root'
    cwd '/var/www'
    only_if "test -f /var/www/index.html"
  end
end

#!/bin/bash
#
# Installing Dependencies
#
#apt-get install -y php5-xsl php5-cli php5-curl php5-gd php5-mysql php-pear php5-suhosin php-gettext ttf-dejavu-core libmcrypt4 libt1-5 fontconfig-config libxpm4 libgd2-xpm php5-mcrypt libjpeg62
#
# Downloading Package
#
# cd default['ximdex']['params_path']
# wget www.ximdex.org/resources/download/ximdex_3.2_open_r8011.tgz 
# tar zxvf ximdex_3.2_open_r8011.tgz
# mv ximdex_3_2/* .
# rmdir ximdex_3_2/
# #
# #
# #
# # copia del template que hemos generado <----- y lo pones en default['ximdex']['params_path']/install/templates/setup.conf
# ./install/install.sh -a
# chown -R www-data:www-data *
# rm -f index.html