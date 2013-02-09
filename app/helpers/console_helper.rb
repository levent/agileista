module ConsoleHelper
  def show_account_holder(account)
    scrum_master = account.team_members.where('scrum_master = ?', true)
    if scrum_master.any?
      return "#{scrum_master.first.person.name} (#{scrum_master.first.person.email})"
    else
      return "NO ACCOUNT HOLDER"
    end
  end
end
