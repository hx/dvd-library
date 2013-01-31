require 'spec_helper'

describe Title do

  let(:title) { Title.new }

  subject { title }

  it { should respond_to :library }
  it { should respond_to :barcode }
  it { should respond_to :title }

  describe 'xml import' do

    its(:class) { should respond_to :from_xml }

    let(:source) do
      <<-XML
      <DVD>
        <Title>Starsky &amp; Hutch</Title>
        <UPC>123-456-789</UPC>
      </DVD>
      XML
    end

    let(:title) { Title.from_xml source }

    it { should be_an_instance_of Title }
    its(:title)   { should == 'Starsky & Hutch' }
    its(:barcode) { should == '123456789' }

  end

end

