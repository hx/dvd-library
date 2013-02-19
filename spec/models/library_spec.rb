# == Schema Information
#
# Table name: libraries
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  name         :string(255)      default("")
#  tmdb_api_key :string(255)
#  tvdb_api_key :string(255)
#

require 'spec_helper'

describe Library do

  let(:library) { Library.new }

  subject { library }

  it { should respond_to :titles }
  it { should respond_to :name }
  it { should respond_to :tmdb_api_key }
  it { should respond_to :tvdb_api_key }

end
