class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :view

  protected

  def view
    @view
  end

end
