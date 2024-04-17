# frozen_string_literal: true

# This controller is the parent controller for all other controllers in the application.
class ApplicationController < ActionController::Base
  include Pagy::Backend

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
