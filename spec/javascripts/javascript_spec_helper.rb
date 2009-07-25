require "#{File.dirname(__FILE__)}/../spec_helper"

def run_javascript_spec(name, view, &setup)
  name = name.downcase.underscore
  plugin_prefix = "#{RAILS_ROOT}/vendor/plugins/blue-ridge"
  rhino_command = "java -jar #{plugin_prefix}/lib/js.jar -w -debug"
  test_runner_command = "#{rhino_command} #{plugin_prefix}/lib/test_runner.js"

  html_layout = lambda { |body|
    <<-HTML.gsub(/^    /, '')
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    
    <head>
      <title>#{name.capitalize} | JavaScript Testing Results</title>
      <link rel="stylesheet" href="screw.css" type="text/css" charset="utf-8" /> 
      <script type="text/javascript" src="../../../vendor/plugins/blue-ridge/lib/blue-ridge.js"></script>
    </head>
    
    <body>
      <!-- Put any HTML fixture elements here. -->
      #{body}
    </body>
    </html>
    HTML
  }

  describe view, :type => :view do
    before(&setup)

    it "should pass javascript tests" do
      render
      File.open(File.join(File.dirname(__FILE__), "fixtures/#{name}.html"), 'w') do |f|
        f.write html_layout.call(response.body)
      end
      Dir.chdir(File.join(File.dirname(__FILE__))) do
        puts "\n"
        unless system("#{test_runner_command} #{name}_spec.js")
          flunk "javascript test failure"
        end
      end
    end
  end
end