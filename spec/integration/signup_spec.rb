require 'spec_helper'

describe "the signup process" do
  it "signs me up" do
    visit '/'
    fill_in 'Account name', :with => 'qatester'
    fill_in 'Site address', :with => 'qat'
    fill_in 'Your name', :with => 'Levent Ali'
    fill_in 'Your email', :with => 'lebreeze@gmail.com'
    fill_in 'Password', :with => 'pa55word'
    fill_in 'Confirm your password', :with => 'pa55word'
    click_button 'Create account'
    page.should have_content 'Congratulations you have registered successfully.'
  end
end
