class JavascriptSpecGenerator < Rails::Generator::NamedBase
  def manifest
    file_path_with_spec, file_path_without_spec = file_path_with_and_without_spec
    
    record do |m|
      m.directory "#{base_dir}/#{dir_path}"
      m.directory "#{base_dir}/fixtures/#{dir_path}"
      
      options = {:class_name_without_spec => class_name_without_spec, :file_path_without_spec => file_path_without_spec}
      m.template 'javascript_spec.js.erb', "#{base_dir}/#{file_path_with_spec}.js", :assigns => options
      if rspec? && !actions.blank?
        # actions - list of templates to render
        m.template 'fixture_render_spec.rb.erb', "#{base_dir}/#{file_path_with_spec}.rb", :assigns => options
      else
        m.template 'fixture.html.erb', "#{base_dir}/fixtures/#{file_path_without_spec}.html", :assigns => options
      end
    end
  end

  def rspec?
    File.exist?("spec")
  end
  
  def base_dir
    @base_dir ||= File.exist?("spec") ? "spec/javascripts" : "test/javascript"
  end
  
  def dir_path
    File.dirname(file_path)
  end
  
  def file_path_with_and_without_spec
    if (file_path =~ /_spec$/i)
      [file_path, file_path.gsub(/_spec$/, "")]
    else
      [file_path + "_spec", file_path]
    end
  end
  
  def class_name_without_spec
    (class_name =~ /Spec$/) ? class_name.gsub(/Spec$/, "") : class_name
  end
end
