# == Schema Information
#
# Table name: libraries
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)      default("")
#

require 'spec_helper'

describe Library do

  let(:library) { Library.new }

  subject { library }

  it { should respond_to :titles }
  it { should respond_to :name }

end
