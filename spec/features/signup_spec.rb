require 'spec_helper'

describe "the signup process" do
  it "signs me up" do
    visit '/people/sign_up'
    fill_in 'Name', :with => 'Levent Ali'
    fill_in 'Email', :with => 'lebreeze@gmail.com'
    fill_in 'person_password', :with => 'pa55word'
    fill_in 'Password confirmation', :with => 'pa55word'
    click_button 'Sign up'
    page.should have_content 'You need to sign in or sign up before continuing.'
  end
end
