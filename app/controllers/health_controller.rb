class HealthController < ActionController::Metal
  def index
    if File.exist?("#{Rails.root}/MAINTENANCE")
      self.status = 404
      self.response_body = "Not Found"
    else
      self.status = 200
      self.response_body = "OK"
    end
  end
end
