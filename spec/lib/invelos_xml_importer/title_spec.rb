require 'spec_helper'

describe InvelosXmlImporter::Title do

  subject { InvelosXmlImporter::Title.new }

  it { should be_an_instance_of InvelosXmlImporter::Title }

  describe 'xml import' do

    let(:source) do
      <<-XML
      <DVD>
        <Title>The Quick &amp; the Dead</Title>
        <SortTitle>Quick &amp; the Dead, The</SortTitle>
        <UPC>123-456-789</UPC>
        <ProductionYear>1999</ProductionYear>
        <Released>2005-02-08</Released>
        <RunningTime>93</RunningTime>
        <Overview>Gun slingin&apos;</Overview>
        <Rating>M</Rating>
        <Actors>
          <Actor FirstName="Leonardo" LastName="di Caprio" Role="Kid" />
          <Actor FirstName="Russell" LastName="Crowe" Role="Priest" />
        </Actors>
        <Credits>
          <Credit FirstName="Bob" LastName="Smith" CreditType="Direction" CreditSubtype="Director" />
        </Credits>
      </DVD>
      XML
    end

    let(:title) { Title.from_xml source }

    subject { title }

    it { should be_an_instance_of Title }
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

  end

end