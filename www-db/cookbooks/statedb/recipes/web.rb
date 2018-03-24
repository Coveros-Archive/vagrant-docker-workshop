#
# Cookbook:: statedb
# Recipe:: web
#
# Copyright:: 2018, Coveros
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

# Install Apache and start the service.
httpd_service 'state' do
  mpm 'prefork'
  log_level 'debug'
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'state' do
  instance 'state'
  source 'state.conf.erb'
  notifies :restart, 'httpd_service[state]'
end

# Create the document root directory.
directory node['statedb']['document_root'] do
  recursive true
end

# Set up the home page
template "#{node['statedb']['document_root']}/index.php" do
  source "index.php.erb"
  variables(
		:name => 'STAREast 2018',
		:db_host => "192.168.33.10",
		:db_name => node['statedb']['database']['dbname'],
		:db_user => node['statedb']['database']['statedb_username'],
		:db_pass => node['statedb']['database']['statedb_password']
	)
end

# Install the mod_php7.1 Apache module.
httpd_module 'php7.1' do
  instance 'state'
  package_name 'libapache2-mod-php7.1'
end
remote_file 'fix mod_php7.1.load' do
  path '/etc/apache2-state/mods-enabled/php7.1.load'
  source 'file:///etc/apache2/mods-enabled/php7.1.load'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'httpd_service[state]'
end

# Install php7.1-mysql.
package 'php7.1-mysql' do
  action :install
  notifies :restart, 'httpd_service[state]'
end
