class AccountController < AbstractSecurityController
  def generate_api_key
    current_person.update_attribute(:api_key, Digest::SHA256.hexdigest("#{Time.now}---#{rand(10000)}"))
    redirect_to :back
  end
end
