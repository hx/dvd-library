# == Schema Information
#
# Table name: titles
#
#  id                     :integer          not null, primary key
#  barcode                :string(255)
#  title                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  overview               :text
#  sort_title             :string(255)
#  production_year        :integer
#  release_date           :date
#  runtime                :integer
#  certification          :string(255)
#  library_id             :integer
#  parent_id              :integer
#  vendor_id              :string(255)
#  third_party_poster_url :string(255)
#

require 'spec_helper'

describe Title do

  let(:title) { Title.new }

  subject { title }

  it 'should respond to a few methods' do
    %w|
      id
      barcode
      title
      overview
      sort_title
      production_year
      release_date
      runtime
      certification
      roles
      people
      parent
      children
      vendor_id
      poster
      third_party_poster_url
    |.each { |w| title.should respond_to w.to_sym }
  end

  describe 'xml import' do

    let(:source) { SAMPLE_TITLE_XML }

    let(:title) { Title.from_xml source }

    it { should be_an_instance_of Title }
    its(:vendor_id)       { should == 'SAMPLE_TITLE.2' }
    its(:title)           { should == 'The Quick & the Dead' }
    its(:sort_title)      { should == 'Quick & the Dead, The' }
    its(:barcode)         { should == '123456789' }
    its(:production_year) { should == 1999 }
    its(:release_date)    { should == Date.new(2005, 2, 8) }
    its(:runtime)         { should == 93 }
    its(:overview)        { should == "Gun slingin'" }
    its(:certification)   { should == 'M' }

    describe 'uniqueness' do

      before do
        title.save!
        @second_copy = Title.from_xml source
      end

      it { should == @second_copy }

    end

    describe 'hierarchy' do

      before do
        @child_title = Title.from_xml SAMPLE_CHILD_XML
        @parent_title = Title.from_xml SAMPLE_PARENT_XML
        title.children.reload
      end

      its(:children)  { should include @child_title }
      its(:parent)    { should == @parent_title }

    end

  end

end

