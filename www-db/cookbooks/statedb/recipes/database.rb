#
# Cookbook:: statedb
# Recipe:: database
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

# Install the MySQL server
mysql_service 'default' do
  version '5.7'
  initial_root_password node['statedb']['database']['root_password']
  action [:create, :start]
end

# Install the MySQL client
mysql_client 'default' do
  action :create
  package_version ''
  version '5.7'
end

# Install the mysql2 Ruby gem for the database resources
package 'libmysqlclient-dev'
mysql2_chef_gem 'default' do
  action :install
  package_version '5.7.21-0ubuntu0.17.10.1'
end

# Collect connection info for reuse
mysql_connection_info = {
	:host => node['statedb']['database']['host'],
	:username => node['statedb']['database']['root_username'],
	:password => node['statedb']['database']['root_password']
}

# Create database
mysql_database node['statedb']['database']['dbname'] do
  connection mysql_connection_info
  action [:drop, :create]
end

# Make a database user
mysql_database_user node['statedb']['database']['statedb_username'] do
  connection mysql_connection_info
  password node['statedb']['database']['statedb_password']
  database_name node['statedb']['database']['dbname']
  host '%'
  privileges [:select]
  action [:create, :grant]
end

# Create the table
create_tables_script_path = File.join(Chef::Config[:file_cache_path], 'states-table.sql')
cookbook_file create_tables_script_path do
  source 'states-table.sql'
  owner 'root'
  group 'root'
  mode '0600'
end
mysql_database node['statedb']['database']['dbname'] do
  connection mysql_connection_info
  sql { ::File.open(create_tables_script_path).read }
  action :query
end

# Populate the table
insert_data_script_path = File.join(Chef::Config[:file_cache_path], 'states-data.sql')
cookbook_file insert_data_script_path do
  source 'states-data.sql'
  owner 'root'
  group 'root'
  mode '0600'
end
mysql_database node['statedb']['database']['dbname'] do
  connection mysql_connection_info
  sql { ::File.open(insert_data_script_path).read }
  action :query
end
