module AccountStuff
  AccountStuff::RESERVED_SUBDOMAINS = %w(app www site we blog dev stage)
  AccountStuff::TEAM_AGILEISTA = ["lebreeze@gmail.com"]
  AccountStuff::MASTER_SUBDOMAIN = "app"
  AccountStuff::DOMAIN = "agileista.com"
  AccountStuff::SIGNUP_SITE = "#{AccountStuff::MASTER_SUBDOMAIN}.#{AccountStuff::DOMAIN}"
end
