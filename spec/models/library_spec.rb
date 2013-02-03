# == Schema Information
#
# Table name: libraries
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Library do

  let(:library) { Library.new }

  subject { library }

  it { should respond_to :titles }

end
