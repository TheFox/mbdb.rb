
require 'pathname'
require 'digest/sha1'

module TheFox
	module MBDB
		
		class Record
			
			attr_reader :domain
			attr_accessor :path
			attr_accessor :file_size
			
			def initialize
				@domain_name = ''
				@domain = nil
				@path = ''
				@file_size = 0
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
