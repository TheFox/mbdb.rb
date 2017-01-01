
require 'pathname'

module TheFox
	module MBDB
		
		class MBDB
			
			LOOP_MAX = 10000
			
			attr_reader :file_path
			attr_reader :records
			
			def initialize(file_path = nil)
				@file_path = file_path
				@file_h = nil
				@offset = 0
				@buffer = ''
				@records = Array.new
				
				unless file_path.nil?
					read(file_path)
				end
			end
			
			def read(file_path = nil)
				if file_path.nil?
					file_path = @file_path
				end
				
				return false unless file_path.exist?
				
				@file_h = File.open(file_path, 'rb')
				@file_h.read(6) # header
				@offset += 6
				
				loops = 0
				while read_buffer && loops < LOOP_MAX
					loops += 1
					
					domain = parse_string
					path = parse_string
					
					parse_string
					parse_string
					parse_string
					parse_int16
					parse_int32
					parse_int32
					parse_int32
					parse_int32
					parse_int32
					parse_int32
					parse_int32
					
					file_size = parse_int64
					
					parse_int8
					
					property_count = parse_int8
					property_count.times do |n|
						read_buffer || break
						parse_string
						
						read_buffer || break
						parse_string
					end
					
					record = Record.new
					record.domain = domain
					record.path = Pathname.new(path)
					record.file_size = file_size
					
					records << record
				end
				@file_h.close
				
				if loops == LOOP_MAX
					raise "Main loop has reached #{loops}"
				end
			end
			
			private
			
			def read_buffer
				b_len = @buffer.length
				if @file_h.eof?
					b_len > 0
				else
					if b_len < 0xffff
						@buffer << @file_h.read(0xffff)
					end
					
					true
				end
			end
			
			def parse_int8
				i = @buffer[0].unpack('C')
				@buffer.slice!(0)
				@offset += 1
				i.shift.to_i
			end
			
			def parse_int16
				i = @buffer[0, 2].unpack('n')
				@buffer.slice!(0..1)
				@offset += 2
				i.shift.to_i
			end
			
			def parse_int32
				i = @buffer[0, 4].unpack('N')
				@buffer.slice!(0..3)
				@offset += 4
				i.shift.to_i
			end
			
			def parse_int64
				higher, lower = @buffer[0, 8].unpack('N2').map{ |n| n.to_i }
				i = (higher << 32) | lower
				
				@buffer.slice!(0..7)
				@offset += 8
				
				i
			end
			
			def parse_string
				len = parse_int16
				
				if len == 0 || len == 0xffff
					return ''
				end
				
				str = @buffer[0, len]
				@buffer.slice!(0..(len - 1))
				
				str
			end
			
		end
		
	end
end
