#
# Cookbook:: statedb
# Attribute:: default
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

node.default['statedb']['database']['root_password'] = 'My hovercraft is full of eels.'
node.default['statedb']['database']['dbname'] = 'statedb'
node.default['statedb']['database']['host'] = '127.0.0.1'
node.default['statedb']['database']['root_username'] = 'root'

node.default['statedb']['database']['statedb_password'] = 'Can you direct me to the station?'
node.default['statedb']['database']['statedb_username'] = 'state_user'

node.default['statedb']['document_root'] = '/var/www/html'
