require 'spec_helper'

describe InvelosXmlImporter::Title do

  subject { InvelosXmlImporter::Title.new }

  it { should be_an_instance_of InvelosXmlImporter::Title }

  describe 'xml import' do

    let(:source) do
      <<-XML
      <DVD>
        <Title>Starsky &amp; Hutch</Title>
        <UPC>123-456-789</UPC>
      </DVD>
      XML
    end

    let(:title) { Title.from_xml source.gsub(/\d{3}/) {|m| srand; rand(100..999).to_s } }

    subject { title }

    it { should be_an_instance_of Title }
    its(:title)   { should == 'Starsky & Hutch' }
    its(:barcode) { should =~ /^\d{9}$/ }

    describe 'uniqueness' do

      before do
        title.save!
        @second_copy = Title.from_xml source.gsub /[-\d]+/, title.barcode
      end

      it { should == @second_copy }

    end

  end

end