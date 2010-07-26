# DO NOT MODIFY THIS FILE
# Generated by Bundler 0.9.26

require 'digest/sha1'
require 'yaml'
require 'pathname'
require 'rubygems'
Gem.source_index # ensure Rubygems is fully loaded in Ruby 1.9

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  class Specification < Gem::Specification
    attr_accessor :relative_loaded_from

    def self.from_gemspec(gemspec)
      spec = allocate
      gemspec.instance_variables.each do |ivar|
        spec.instance_variable_set(ivar, gemspec.instance_variable_get(ivar))
      end
      spec
    end

    def loaded_from
      return super unless relative_loaded_from
      source.path.join(relative_loaded_from).to_s
    end

    def full_gem_path
      Pathname.new(loaded_from).dirname.expand_path.to_s
    end
  end

  module SharedHelpers
    attr_accessor :gem_loaded

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "Could not locate Gemfile"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

    def env_file
      default_gemfile.dirname.join(".bundle/environment.rb")
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten
      Gem.source_index # ensure RubyGems is fully loaded

     ::Kernel.class_eval do
        private
        def gem(*) ; end
      end

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        gem_bin = File.join(spec.full_gem_path, spec.bindir, exec_name)
        gem_from_path_bin = File.join(File.dirname(spec.loaded_from), spec.bindir, exec_name)
        File.exist?(gem_bin) ? gem_bin : gem_from_path_bin
      end
    end

    extend self
  end
end

module Bundler
  ENV_LOADED   = true
  LOCKED_BY    = '0.9.26'
  FINGERPRINT  = "5b0b3ffb3d1d3fbfd00d37e1fdb529547fea55ac"
  HOME         = '/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/bundler'
  AUTOREQUIRES = {:test=>[["faker", false], ["machinist", false], ["mocha", false], ["pdf-reader", false], ["shoulda", true]], :default=>[["authlogic", false], ["cancan", false], ["prawn", false], ["rails", false], ["redgreen", false], ["zip/zip", true], ["searchlogic", false], ["sqlite3", true], ["constant_cache", true], ["will_paginate", false]]}
  SPECS        = [
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%global/gems/rake-0.8.7/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%global/specifications/rake-0.8.7.gemspec", :name=>"rake"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/Ascii85-1.0.0/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/Ascii85-1.0.0.gemspec", :name=>"Ascii85"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/activesupport-2.3.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/activesupport-2.3.5.gemspec", :name=>"activesupport"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/rack-1.0.1/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/rack-1.0.1.gemspec", :name=>"rack"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/actionpack-2.3.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/actionpack-2.3.5.gemspec", :name=>"actionpack"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/actionmailer-2.3.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/actionmailer-2.3.5.gemspec", :name=>"actionmailer"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/activerecord-2.3.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/activerecord-2.3.5.gemspec", :name=>"activerecord"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/activeresource-2.3.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/activeresource-2.3.5.gemspec", :name=>"activeresource"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/authlogic-2.1.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/authlogic-2.1.5.gemspec", :name=>"authlogic"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/cancan-1.2.0/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/cancan-1.2.0.gemspec", :name=>"cancan"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/faker-0.3.1/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/faker-0.3.1.gemspec", :name=>"faker"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/machinist-1.0.6/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/machinist-1.0.6.gemspec", :name=>"machinist"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/mocha-0.9.8/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/mocha-0.9.8.gemspec", :name=>"mocha"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/pdf-reader-0.8.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/pdf-reader-0.8.5.gemspec", :name=>"pdf-reader"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/prawn-core-0.8.4/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/prawn-core-0.8.4.gemspec", :name=>"prawn-core"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/prawn-layout-0.8.4/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/prawn-layout-0.8.4.gemspec", :name=>"prawn-layout"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/prawn-security-0.8.4/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/prawn-security-0.8.4.gemspec", :name=>"prawn-security"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/prawn-0.8.4/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/prawn-0.8.4.gemspec", :name=>"prawn"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/rails-2.3.5/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/rails-2.3.5.gemspec", :name=>"rails"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/redgreen-1.2.2/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/redgreen-1.2.2.gemspec", :name=>"redgreen"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/rubyzip-0.9.4/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/rubyzip-0.9.4.gemspec", :name=>"rubyzip"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/searchlogic-2.4.21/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/searchlogic-2.4.21.gemspec", :name=>"searchlogic"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/sqlite3-ruby-1.2.5/lib", "/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/sqlite3-ruby-1.2.5/ext"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/sqlite3-ruby-1.2.5.gemspec", :name=>"sqlite3-ruby"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/thoughtbot-shoulda-2.11.1/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/thoughtbot-shoulda-2.11.1.gemspec", :name=>"thoughtbot-shoulda"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/tpitale-constant_cache-0.1.2/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/tpitale-constant_cache-0.1.2.gemspec", :name=>"tpitale-constant_cache"},
        {:load_paths=>["/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/gems/will_paginate-2.3.14/lib"], :loaded_from=>"/Users/tom/.rvm/gems/ruby-1.8.7-p249%bundler2/specifications/will_paginate-2.3.14.gemspec", :name=>"will_paginate"},
      ].map do |hash|
    if hash[:virtual_spec]
      spec = eval(hash[:virtual_spec], TOPLEVEL_BINDING, "<virtual spec for '#{hash[:name]}'>")
    else
      dir = File.dirname(hash[:loaded_from])
      spec = Dir.chdir(dir){ eval(File.read(hash[:loaded_from]), TOPLEVEL_BINDING, hash[:loaded_from]) }
    end
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    if spec.loaded_from.include?(HOME)
      Bundler::Specification.from_gemspec(spec)
    else
      spec
    end
  end

  extend SharedHelpers

  def self.configure_gem_path_and_home(specs)
    # Fix paths, so that Gem.source_index and such will work
    paths = specs.map{|s| s.installation_path }
    paths.flatten!; paths.compact!; paths.uniq!; paths.reject!{|p| p.empty? }
    ENV['GEM_PATH'] = paths.join(File::PATH_SEPARATOR)
    ENV['GEM_HOME'] = paths.first
    Gem.clear_paths
  end

  def self.match_fingerprint
    lockfile = File.expand_path('../../Gemfile.lock', __FILE__)
    lock_print = YAML.load(File.read(lockfile))["hash"] if File.exist?(lockfile)
    gem_print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))

    unless gem_print == lock_print
      abort 'Gemfile changed since you last locked. Please run `bundle lock` to relock.'
    end

    unless gem_print == FINGERPRINT
      abort 'Your bundled environment is out of date. Run `bundle install` to regenerate it.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    configure_gem_path_and_home(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      spec.require_paths.each do |path|
        $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
      end
    end
    self
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group.to_sym] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Set up load paths unless this file is being loaded after the Bundler gem
  setup unless defined?(Bundler::GEM_LOADED)
end
