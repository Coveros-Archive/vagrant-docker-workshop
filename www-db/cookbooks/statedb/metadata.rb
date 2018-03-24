name 'statedb'
maintainer 'Coveros'
maintainer_email 'gene.gotimer@coveros.com'
license 'Apache-2.0'
description 'Installs/Configures statedb'
long_description 'Installs/Configures statedb'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

issues_url 'https://github.com/Coveros/vagrant-docker-workshop/issues'
source_url 'https://github.com/Coveros/vagrant-docker-workshop'

depends 'mysql', '~> 8.5.1'
depends 'mysql2_chef_gem', '~> 2.1.0'
depends 'database', '~> 6.1.1'
depends 'httpd', '~> 0.6.2'
