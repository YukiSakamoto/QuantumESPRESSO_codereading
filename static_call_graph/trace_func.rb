

require 'pathname'

def read_file(filename)
  unless File.exist?(filename)
    raise
  end

  func_table = {}
  
  File.open(filename) do |file|
    in_subroutine = false
    current_func_name = nil

    file.each_line do |line|
	  line.lstrip!()

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

def output(table, start_func, max_depth, def_file_table = nil)
  def _output(table, start_func, max_depth, depth, def_file_table = nil)
	print_child = false
	if depth < max_depth and table.has_key?(start_func) and 0 < table[start_func].length()
		print_child = true
	end

	print_marker = false
	if print_child == true && 2 < table[start_func].uniq().length()
		if 1 <= depth then print_marker = true end
	end

	open_marker = "{{{"
	close_marker= "}}}"
    
	title = ""
	if 1 <= depth then 
		title = "|  " * (depth-1) + "+--" 
	end
	title += start_func
	if def_file_table != nil and def_file_table.has_key?(start_func)
		title += " (#{def_file_table[start_func] })"
	end

	if print_marker
		title += "  #{open_marker} #{depth}" 
	end
    puts title

	if print_child
      callee_func_list = table[start_func].uniq()
      callee_func_list.each do |callee_func|
		  _output(table, callee_func, max_depth, depth+1, def_file_table)
      end

	  if print_marker
		  close_title = ""
		  if 1 <= depth
			  close_title += "|  " * (depth - 1) + "|  " + "*"
		  else
			  close_title += "|  " * depth + " * "
		  end
		  close_title += close_marker
		  puts close_title
	  end

    end


  end

  _output(table, start_func, max_depth, 0, def_file_table)
end



if $0 == __FILE__
	if ARGV.length < 2
		raise
	end

	root_dir = ARGV[0]
	start_subroutine = ARGV[1]
	depth = ARGV[2].to_i

	basepath = Pathname.new(root_dir)

	src_wc_list = []
	src_wc_list << basepath.join( "PW/src",    "*.f90")
	src_wc_list << basepath.join( "PHonon/PH", "*.f90")
	src_wc_list << basepath.join( "PP/src",    "*.f90")
	src_wc_list << basepath.join( "Modules",   "*.f90")
	src_wc_list << basepath.join( "FFTXLib",   "*.f90")
	src_wc_list << basepath.join( "UtilXLib",  "*.f90")

	# Expand the wild card
	file_list = []
	src_wc_list.each do |wc| 
		tmp = Pathname.glob(wc)
		if tmp.length == 0 then STDERR.write("warning: No files are matched to  #{src}") end
		file_list += tmp
	end
	
  	all_table = {}
	def_file_table = {}
  	file_list.each do |filename| 
		tmp_table_ = read_file(filename)
		tmp_table_.each do |key, val|
			def_file_table[key] = filename.relative_path_from(basepath)
		end
		all_table.merge!( tmp_table_ ) 
		
	end
  	output(all_table, start_subroutine, depth, def_file_table)
end
