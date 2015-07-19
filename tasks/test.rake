require 'aws-sdk'
require 'yaml'
require 'highline/import'

namespace :ec2 do
  desc 'List exist instances'
  task :list do
    ec2 = AWS::EC2::Test.new
    p ec2.method
#    ec2.instances.each do |instance|
#      puts([instance.id, instance.image_id, instance.status].join(' '))
#    end
    p ec2.describe_instance_status
  end
end



class AWS::EC2::Test
  def initialize
    @ec2 = AWS::EC2.new(aws_settings).client
  end

  def instances
    @ec2.instances
  end

  private

  def aws_settings
    settings_yml = File.join(__dir__, '../config/aws.yml')
    @aws_settings ||= YAML.load(open(settings_yml))
  end

  def instance_settings
    settings_yml = File.join(__dir__, '../config/instances.yml')
    @instance_settings ||= YAML.load(open(settings_yml))
  end
end
