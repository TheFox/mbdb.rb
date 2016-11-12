
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
					readx(file_path)
				end
			end
			
			def readx(file_path = nil)
				if file_path.nil?
					file_path = @file_path
				end
				
				return false unless file_path.exist?
				
				@file_h = File.open(file_path, 'rb')
				@file_h.read(6) # header
				@offset += 6
				
				loops = 0
				while read_buffer && loops < LOOP_MAX
					# puts "loop #{loops}"
					
					loops += 1
					
					domain = parse_string
					# puts
					
					path = parse_string
					# puts
					
					# puts "domain '#{domain}'"
					# puts "path '#{path}'"
					# puts
					
					parse_string
					# puts
					parse_string
					# puts
					parse_string
					# puts
					parse_int16
					
					# puts
					parse_int32
					# puts
					parse_int32
					# puts
					parse_int32
					# puts
					parse_int32
					# puts
					parse_int32
					# puts
					parse_int32
					# puts
					parse_int32
					# puts
					
					# puts "buffer len #{@buffer.length}"
					
					file_size = parse_int64
					# puts "file_size = #{file_size}"
					
					parse_int8
					
					property_count = parse_int8
					# puts "property count: #{property_count}"
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
					
					# puts "record #{@buffer.length}"
					
					# break
					
					#@buffer = ''
					
					# sleep 1
				end
				@file_h.close
				
				if loops == LOOP_MAX
					raise "Main loop has reached #{loops}"
				end
				
				puts "loops #{loops}"
			end
			
			private
			
			def read_buffer
				b_len = @buffer.length
				# puts "read_buffer A: #{@buffer.length}"
				if @file_h.eof?
					b_len > 0
				else
					if b_len < 0xffff
						@buffer << @file_h.read(0xffff)
					end
					
					# puts "read_buffer B: #{@buffer.length}"
					
					true
				end
			end
			
			def parse_int8
				# puts "parse_int8 len A #{@buffer.length}"
				i = @buffer[0].unpack('C')
				@buffer.slice!(0)
				# puts "parse_int8 len B #{@buffer.length}"
				@offset += 1
				# puts "parse_int8 i=#{i}"
				i.shift.to_i
			end
			
			def parse_int16
				# puts "parse_int16 len A #{@buffer.length}"
				i = @buffer[0, 2].unpack('n')
				@buffer.slice!(0..1)
				# puts "parse_int16 len B #{@buffer.length}"
				@offset += 2
				# puts "parse_int16 i=#{i}"
				i.shift.to_i
			end
			
			def parse_int32
				# puts "parse_int32 len A #{@buffer.length}"
				i = @buffer[0, 4].unpack('N')
				@buffer.slice!(0..3)
				# puts "parse_int32 len B #{@buffer.length}"
				@offset += 4
				# puts "parse_int32 i=#{i}"
				i.shift.to_i
			end
			
			def parse_int64
				# puts "parse_int64 len A #{@buffer.length}"
				higher, lower = @buffer[0, 8].unpack('N2').map{ |n| n.to_i }
				# puts "int64 h=#{higher} l=#{lower}"
				
				i = (higher << 32) | lower
				# puts "int64 i=#{i}"
				
				@buffer.slice!(0..7)
				# puts "parse_int64 len B #{@buffer.length}"
				@offset += 8
				# puts "parse_int64 i=#{i}"
				# i.shift.to_i
				i
			end
			
			def parse_string
				len = parse_int16
				# puts "parse_string #{len}"
				
				if len == 0 || len == 0xffff
					return ''
				end
				# if len == 0xffff
				# 	raise "parse_string, wrong len: #{len}"
				# end
				
				# puts "parse_string len A #{@buffer.length}"
				str = @buffer[0, len]
				@buffer.slice!(0..(len - 1))
				
				# puts "parse_string len B #{@buffer.length}"
				
				str
			end
			
		end
		
	end
end
