#!/usr/bin/env rspec
require 'spec_helper'
require 'pry'

describe 'puppet::master::install', :type => :class do
  let (:default_params) {{'hiera_eyaml_version' => 'installed'}}
  context 'input validation' do

#    ['path'].each do |paths|
#      context "when the #{paths} parameter is not an absolute path" do
#        let (:params) {{ paths => 'foo' }}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"foo" is not an absolute path/)
#        end
#      end
#    end#absolute path

#    ['array'].each do |arrays|
#      context "when the #{arrays} parameter is not an array" do
#        let (:params) {{ arrays => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not an Array./)
#        end
#      end
#    end#arrays

#    ['bool'].each do |bools|
#      context "when the #{bools} parameter is not an boolean" do
#        let (:params) {{bools => "BOGON"}}
#        it 'should fail' do
#          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean.  It looks to be a String/)
#        end
#      end
#    end#bools

#    ['hash'].each do |hashes|
#      context "when the #{hashes} parameter is not an hash" do
#        let (:params) {{ hashes => 'this is a string'}}
#        it 'should fail' do
#           expect { subject }.to raise_error(Puppet::Error, /is not a Hash./)
#        end
#      end
#    end#hashes

    ['hiera_eyaml_version','puppet_version'].each do |strings|
      context "when the #{strings} parameter is not a string" do
        let (:params) {default_params.merge({strings => false })}
        it 'should fail' do
          expect { subject }.to raise_error(Puppet::Error, /false is not a string./)
        end
      end
    end#strings

  end#input validation
  ['Debian'].each do |osfam|
    context "When on an #{osfam} system" do
      let (:pre_condition){"package{'puppet': ensure => 'present'}"}
      let (:facts) {{'osfamily' => osfam}}
      context 'when fed no parameters' do
        let (:params){default_params}

        it 'should install the puppetmaster-common package' do
          should contain_package('puppetmaster-common').with({
            :ensure=>"installed",
          }).that_requires('Package[puppet]')
        end

        it 'should install the puppetmaster package' do
          should contain_package('puppetmaster').with({
            :ensure=>"installed",
          }).that_requires('Package[puppetmaster-common]')
        end

        it 'should install the puppetmaster-passenger package' do
          should contain_package('puppetmaster-passenger').with({
            :ensure=>"installed",
          }).that_requires("Package[puppetmaster]").that_requires("Service[puppetmaster]")
        end

        it 'should install the hiera-eyaml package' do
          should contain_package('hiera-eyaml').with({
            :ensure => 'installed',
            :provider => 'gem'
          })
        end

        it 'should disable the puppetmaster service' do
          should contain_service('puppetmaster').with({
            :ensure=>"stopped",
            :enable=>false,
          }).that_requires('Package[puppetmaster]')
        end

        it 'should remove the default puppetmaster.conf vhost file from /etc/apache2/sites-available' do
          should contain_file('/etc/apache2/sites-available/puppetmaster.conf').with({
            :ensure => 'absent'
            }).that_requires('Package[puppetmaster-passenger]')
        end

        it 'should remove the default puppetmaster.conf vhost file from /etc/apache2/sites-enabled' do
          should contain_file('/etc/apache2/sites-enabled/puppetmaster.conf').with({
            :ensure => 'absent'
            }).that_requires('Package[puppetmaster-passenger]')
        end
      end#no params
      context 'when the hiera_eyaml_version param has a non-standard value' do
        let (:params){default_params.merge({'hiera_eyaml_version' => 'BOGON'})}
        it 'should install the specified version of the hiera-eyaml package' do
          should contain_package('hiera-eyaml').with({
            :name=>"hiera-eyaml",
            :ensure=>"BOGON",
            :provider=>"gem"
          })
        end
      end
      context 'when the puppet_version param has a non-standard value' do
        let (:params){default_params.merge({'puppet_version' => 'BOGON'})}
        it 'should install the specified version of the puppetmaster-common package' do
          should contain_package('puppetmaster-common').with({
            :ensure=>"BOGON",
          }).that_requires('Package[puppet]')
        end

        it 'should install the specified version of the puppetmaster package' do
          should contain_package('puppetmaster').with({
            :ensure=>"BOGON",
          }).that_requires('Package[puppetmaster-common]')
        end

        it 'should install the specified version of the puppetmaster-passenger package' do
          should contain_package('puppetmaster-passenger').with({
            :ensure=>"BOGON",
          }).that_requires("Package[puppetmaster]").that_requires("Service[puppetmaster]")
        end
      end
    end
  end
end
