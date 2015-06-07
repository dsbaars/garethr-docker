require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:get_docker_containers, :type => :rvalue, :doc => <<-EOS
Give a list of hosted docker containers
    EOS
  ) do |args|
      req = []
      scope = self
      #scope.compiler.resources.find_all do |resource|
      #  puts resource.type
      #end
      resource = scope.catalog.resources.find_all { |r| true }
      if not resource.empty? then
        req << resource
      end
      req.flatten!
      req.each { |r| debug "Found #{r}" }
      req
  end
end
