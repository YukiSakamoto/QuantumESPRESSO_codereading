
def read_file(filename)
  unless File.exist?(filename)
    raise
  end

  func_table = {}
  
  File.open(filename) do |file|
    in_subroutine = false
    current_func_name = nil

    file.each_line do |line|

      if in_subroutine == true

        if line =~ %r{^end\s+program\s+(\w+)}i
          in_subroutine = false
          current_func_name = nil
        end

        if line =~ %r{^end\s+subroutine\s+(\w+)}i
          in_subroutine = false
          current_func_name = nil
        end

        if line =~ %r{call\s+(\w+)\s?\(}i
          # Do someting
          func_table[current_func_name] << $1
        end

      else

        if line =~ %r{^program\s+(\w+)}i
          in_subroutine = true
          current_func_name = $1
          func_table[current_func_name] = []
        end

        if line =~ %r{^subroutine\s+(\w+)}i
          in_subroutine = true
          current_func_name = $1
          func_table[current_func_name] = []
        end

      end


    end
  end

  return func_table
end

def output(table, start_func, max_depth)
  def _output(table, start_func, max_depth, depth)

    if max_depth <= depth then return end
    
    title = "+  " * depth + start_func
    puts title

    if table.has_key?(start_func)
      callee_func_list = table[start_func].uniq()
      callee_func_list.each do |callee_func|
        _output(table, callee_func, max_depth, depth+1)
      end
    end

  end

  _output(table, start_func, max_depth, 0)
end



if $0 == __FILE__
	if ARGV.length < 2
		raise
	end

	root_dir = ARGV[0]
	start_subroutine = ARGV[1]
	depth = ARGV[2].to_i

	src_wc_list = []
	src_wc_list << File.join( root_dir, "PW/src", "*.f90")
	src_wc_list << File.join( root_dir, "PP/src", "*.f90")
	src_wc_list << File.join( root_dir, "Modules", "*.f90")
	src_wc_list << File.join( root_dir, "FFTXLib", "*.f90")
	src_wc_list << File.join( root_dir, "UtilXLib", "*.f90")

	# Expand the wild card
	file_list = []
	src_wc_list.each do |src| 
		file_list += Dir.glob(src)
	end
	
  	all_table = {}
  	file_list.each {|file| all_table.merge!(read_file(file) ) }
  	output(all_table, start_subroutine, 5)
end
