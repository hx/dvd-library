class QunitController < ApplicationController

  layout 'qunit'

  before_filter { head :bad_request unless Rails.env.development? }

  def show
    render text: '', layout: true
  end

  def echo
    render layout: false, text: {
      params: params,
      request: {
        method: request.request_method,
        path: request.fullpath,
        body: request.raw_post
      }
    }.to_json
  end

end