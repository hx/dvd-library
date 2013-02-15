require 'spec_helper'

describe SuggestionsHelper do

  subject { search_suggestions(term) }

  describe 'basic search' do
    let(:term) { 'fubar' }
    its(:to_s) { should == 'search/fubar' }
  end

  describe 'sorting' do
    %w|title release production genre media-type runtime certification|.each do |criteria|
      it "should include a #{criteria} sorting scope" do
        search_suggestions(criteria).to_s.should include "sort/#{criteria}"
      end
    end
  end

  describe 'dates' do
    let(:term) { '1 November 2000' }
    its(:to_s) { should include 'release-date/2000-11-01' }
  end

  describe 'years' do
    let(:term) { '2005' }
    its(:to_s) { should include 'production-year/2005' }
  end

  describe 'genres' do
    before do
      @genre1 = FactoryGirl.create :genre, name: 'Action'
      @genre2 = FactoryGirl.create :genre, name: 'Reenactments'
    end
    let(:term) { 'act' }
    its(:to_s) { should include "genre/#{@genre1.id}" }
    #its(:to_s) { should include "genre/#{@genre2.id}" }
  end

  describe 'studios' do
    before do
      @studio1 = FactoryGirl.create :studio, name: '20th Century Fox'
      @studio2 = FactoryGirl.create :studio, name: 'Fox Home Entertainment'
    end
    let(:term) { 'fox' }
    its(:to_s) { should include "studio/#{@studio1.id}" }
    its(:to_s) { should include "studio/#{@studio2.id}" }
  end

  describe 'media types' do
    before do
      @dvd    = FactoryGirl.create :media_type, name: 'DVD'
      @hddvd  = FactoryGirl.create :media_type, name: 'HDDVD'
      @bluray = FactoryGirl.create :media_type, name: 'BluRay'
    end
    let(:term) { 'dvd' }
    its(:to_s) { should     include "media-type/#{@dvd.id}" }
    its(:to_s) { should     include "media-type/#{@hddvd.id}" }
    its(:to_s) { should_not include "media-type/#{@bluray.id}" }
  end

  describe 'people' do
    before do
      @tim = FactoryGirl.create :person, first_name: 'Tim'
      @jim = FactoryGirl.create :person, first_name: 'Jim'
      @tom = FactoryGirl.create :person, first_name: 'Tom', middle_name: ''
    end
    let(:term) { 'im' }
    its(:to_s) { should include "person/#{@tim.id}" }
    its(:to_s) { should include "person/#{@jim.id}" }
    its(:to_s) { should_not include "person/#{@tom.id}" }
  end

end
