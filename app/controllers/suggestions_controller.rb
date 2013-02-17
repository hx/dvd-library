class SuggestionsController < ApplicationController

  include SuggestionsHelper

  def search
    respond_to do |format|
      format.json do
        scopes = search_suggestions(params[:query] || '')
        render text: {
            scopes: scopes.to_s,
            people: person_index_for(scopes)
        }.to_json
      end
    end
  end
end
