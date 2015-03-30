require 'rake'
require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'

hosts = [
  {
    name:       'ci',
    short_name: 'ci',
    role:       'ci'
  }
]

class ServerspecTask < RSpec::Core::RakeTask
  attr_accessor :target

  def spec_command
    cmd = super
    "env TARGET_HOST=#{target} #{cmd}"
  end
end

namespace :spec do
  desc "Run serverspec to all hosts"
  task :all => hosts.map{|h| 'spec:' + h[:short_name] }
  hosts.each do |host|
    desc "Run serverspec tests to #{host[:name]}"
    ServerspecTask.new(host[:short_name].to_sym) do |t|
      t.target = host[:name]
      t.pattern = "spec/role/#{host[:role]}_spec.rb"
      p #{host}
    end
  end
end

task :default => :spec

Dir['tasks/*.rake'].each do |f|
  load File.join(File.dirname(_FILE_), f)
end

