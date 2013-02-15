require 'spec_helper'

describe SuggestionsController do

  def decode(json); ActiveSupport::JSON.decode json end

  subject { response }

  describe 'generic title search' do

    before { get :search, query: 'fubar', format: :json }

    it { should be_ok }

    describe 'json data' do
      specify { decode(response.body).should == {
        'scopes' => 'search/fubar',
        'people' => {}
      } }
    end

  end

  describe 'data for people' do

    before do
      @title = FactoryGirl.create :title
      @person = FactoryGirl.create :person
      @title.people << @person
      @person.roles.first.department = 'Cast'
      get :search, format: :json, query: @person.first_name.downcase
    end

    it { should be_ok }

    describe 'json data' do
      specify { decode(response.body).should == {
        'scopes' => "search/#{@person.first_name.downcase}/person/#{@person.id}",
        'people' => {
          '1' => {
            'full_name' => @person.full_name,
            'recent_work' => @person.recent_work
          }
        }
      } }
    end

  end

end
