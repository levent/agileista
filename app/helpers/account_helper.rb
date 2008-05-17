module AccountHelper
  def account_holder(user)
    user.account_holder? ? "Account holder" : ""
  end
end
