class QunitController < ApplicationController

  layout 'qunit'

  before_filter { head :bad_request unless Rails.env.development? }

  def show
    render text: '', layout: true
  end

end