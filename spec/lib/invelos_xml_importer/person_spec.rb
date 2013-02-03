require 'spec_helper'

describe InvelosXmlImporter::Person do

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