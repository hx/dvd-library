# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  title_id    :integer
#  person_id   :integer
#  name        :string(255)
#  department  :string(255)
#  credited_as :string(255)
#  uncredited  :boolean
#  voice       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Role do

  let(:role) { Role.new }

  subject { role }

  it 'should respond to a few properties' do
    %w(
      title
      person
      name
      department
      credited_as
      uncredited
      voice
    ).each { |property| role.should respond_to property.to_sym }
  end

  describe 'xml importing' do

    let(:source) { SAMPLE_TITLE_XML }
    let(:title) { Title.from_xml source }

    subject { title.roles }

    its(:count) { should == 3 }

    describe 'cast' do

      subject { title.roles.cast }

      its(:count) { should == 2 }

    end

    describe 'an actor' do

      let(:role) { title.roles.find_by_name 'Kid' }
      subject { role }

      it { should_not be_uncredited }
      it { should_not be_voice }
      specify { role.person.first_name.should == 'Leonardo' }

    end

  end

end
