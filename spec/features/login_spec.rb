require 'rails_helper'

RSpec.feature 'Login process', type: :feature do

  before do
    @person = create_person
  end

  it "logs me in" do
    visit '/people/sign_in'
    fill_in 'Email', :with => @person.email
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully.'
  end
end
