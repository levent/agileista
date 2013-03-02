module ConsoleHelper
  def show_account_holder(project)
    scrum_master = project.scrum_master
    if scrum_master
      return "#{scrum_master.name} (#{scrum_master.email})"
    else
      return "NO ACCOUNT HOLDER"
    end
  end
end
