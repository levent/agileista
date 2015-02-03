require 'spec_helper'

describe "the login process" do
  before do
    @person = Person.make!
    @person.confirm!
  end

  it "logs me in" do
    visit '/people/sign_in'
    fill_in 'Email', :with => @person.email
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    page.should have_content 'Signed in successfully.'
  end
end
