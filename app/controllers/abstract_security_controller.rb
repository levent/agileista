class AbstractSecurityController < ApplicationController
  before_filter :must_be_logged_in
end