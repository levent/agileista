# Run me with:
#
# $ watchr less.watchr

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def lessc(file)
  print "compiling #{file.inspect}... "
  system "lessc #{file}"
  puts 'done'
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch ( '.*\.less$' ) {lessc "application.less" }

# Ctrl-C
Signal.trap('INT') { abort("\n") }

