require 'spec_helper'

describe InvelosXmlImporter::Role do

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