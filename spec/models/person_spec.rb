# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  birth_year  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Person do

  let(:person) { Person.new }

  subject { person }

  it 'should respond to a few properties' do
    %w(
      first_name
      middle_name
      last_name
      birth_year
      roles
      titles
      from_xml
    ).each { |property| person.should respond_to property.to_sym }
  end

  describe 'xml importing' do
    let(:source) { SAMPLE_TITLE_XML }
    let(:title) { Title.from_xml source }

    subject { title.people }

    its(:count) { should == 3 }

    describe 'a person' do

      let(:person) { title.people.find_by_first_name 'Leonardo' }

      subject { person }

      its(:first_name) { should == 'Leonardo' }
      its(:last_name)  { should == 'DiCaprio' }
      its(:birth_year) { should == 1974 }
    end
  end

end
