require 'spec_helper'

describe Title do

  let(:title) { Title.new }

  subject { title }

  it { should respond_to :library }
  it { should respond_to :barcode }
  it { should respond_to :title }

end

