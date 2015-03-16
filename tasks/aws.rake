require 'aws-sdk'
require 'yaml'
require 'highline/import'

namespace :ec2 do
  desc 'List exist instances:'
  task :listtest do
    #ec2 = AWS::EC2.new region: 'ap-northest-1', profile: 'default'
    provider = AWS::Core::CredentialProviders::SharedCredentialFileProvider.new( profile_name: "default")
    ec2 = AWS::EC2.new(credential_provider: provider)
    ec2.instances.each do |instance|
      puts([instance.id, instance.image_id, instance.status].join(' '))
    end
  end
end


