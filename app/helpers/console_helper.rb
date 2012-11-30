module ConsoleHelper
  def show_account_holder(account)
    if account.account_holder
      return "#{account.account_holder.name} (#{account.account_holder.email})"
    else
      return "NO ACCOUNT HOLDER"
    end
  end
end
