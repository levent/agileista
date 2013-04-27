require "jshintrb/jshinttask"
Jshintrb::JshintTask.new :jshint do |t|
  t.js_files = `find app/assets/javascripts -name *.js`.split("\n")
  t.globals = ['d3', 'Agileista']
  t.exclude_js_files = [
    'app/assets/javascripts/d3.v3/d3.v3.js',
    'app/assets/javascripts/d3.v3/d3.v3.min.js',
    'app/assets/javascripts/socket.io.js',
  ]
  t.options = {
    :bitwise => true,
    :curly => true,
    :eqeqeq => true,
    :forin => true,
    :immed => true,
    :latedef => true,
    :newcap => true,
    :noarg => true,
    :noempty => true,
    :nonew => true,
    :plusplus => false,
    :regexp => true,
    :undef => true,
    :strict => false,
    :trailing => true,
    :browser => true,
    :jquery => true,
    :browser => true
  }
end
