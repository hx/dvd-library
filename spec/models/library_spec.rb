require 'spec_helper'

describe Library do

  let(:library) { Library.new }

  subject { library }

  it { should respond_to :titles }

end
