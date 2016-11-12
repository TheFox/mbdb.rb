
require 'pathname'
require 'digest/sha1'

module TheFox
	module MBDB
		
		class Record
			
			attr_reader :domain
			attr_accessor :path
			# attr_accessor :link_target
			# attr_accessor :data_hash
			# attr_accessor :encryption_key
			attr_accessor :file_size
			# attr_accessor :file_name
			
			def initialize
				@domain_name = ''
				@domain = nil
				@path = ''
				# @link_target = ''
				# @data_hash = ''
				# @encryption_key = ''
				@file_size = 0
				# @file_name = ''
			end
			
			def domain=(domain)
				@domain_name = domain
				domains = domain.split('-')
				root_domain = domains.shift
				@domain = Pathname.new(root_domain).join(*domains)
			end
			
			def src_file_name
				Pathname.new(Digest::SHA1.hexdigest("#{@domain_name}-#{@path}"))
			end
			
			def is_file?
				@file_size > 0
			end
			
			def to_s
				"#{@domain}@#{@path}"
			end
			
		end
		
	end
end
