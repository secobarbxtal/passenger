#!/usr/bin/env ruby
module PhusionPassenger
module App
	def self.options
		return @@options
	end
	
	def self.app
		return @@app
	end
	
	def self.handshake_and_read_startup_request
		STDOUT.sync = true
		STDERR.sync = true
		puts "I have control 1.0"
		abort "Invalid initialization header" if STDIN.readline != "You have control 1.0\n"
		
		@@options = {}
		while (line = STDIN.readline) != "\n"
			name, value = line.strip.split(/: */, 2)
			@@options[name] = value
		end
	end
	
	def self.init_passenger
		$LOAD_PATH.unshift(options["ruby_libdir"])
		require 'phusion_passenger'
		PhusionPassenger.locate_directories(options["passenger_root"])
		require 'phusion_passenger/native_support'
		require 'phusion_passenger/ruby_core_enhancements'
		require 'phusion_passenger/utils/tmpdir'
		require 'phusion_passenger/preloader_shared_helpers'
		require 'phusion_passenger/loader_shared_helpers'
		require 'phusion_passenger/rack/request_handler'
		Utils.passenger_tmpdir = options["generation_dir"]
		NativeSupport.disable_stdio_buffering
	rescue Exception => e
		puts "Error"
		puts
		puts e
		puts e.backtrace
		exit 1
	end
	
	def self.preload_app
		LoaderSharedHelpers.before_loading_app_code_step1('config.ru', options)
		LoaderSharedHelpers.run_load_path_setup_code
		LoaderSharedHelpers.before_loading_app_code_step2(options)
		
		require 'rubygems'
		require 'rack'
		rackup_file = ENV["RACKUP_FILE"] || options["rackup_file"] || "config.ru"
		rackup_code = ::File.read(rackup_file)
		@@app = eval("Rack::Builder.new {( #{rackup_code}\n )}.to_app",
			TOPLEVEL_BINDING, rackup_file)
		
		LoaderSharedHelpers.after_loading_app_code(options)
	rescue Exception => e
		puts "Error"
		puts
		puts e
		puts e.backtrace
		exit 1
	end
	
	def self.negotiate_spawn_command
		puts "I have control 1.0"
		abort "Invalid initialization header" if STDIN.readline != "You have control 1.0\n"
		
		while (line = STDIN.readline) != "\n"
			name, value = line.strip.split(/: */, 2)
			options[name] = value
		end
		
		handler = Rack::RequestHandler.new(STDIN, app, options)
		LoaderSharedHelpers.before_handling_requests(true, options)
		puts "Ready"
		LoaderSharedHelpers.advertise_sockets(STDOUT, handler)
		puts
		return handler
	end
	
	
	################## Main code ##################
	
	
	handshake_and_read_startup_request
	init_passenger
	preload_app
	if PreloaderSharedHelpers.run_main_loop(options) == :forked
		handler = negotiate_spawn_command
		handler.main_loop
		LoaderSharedHelpers.after_handling_requests
	end
	
end # module App
end # module PhusionPassenger
