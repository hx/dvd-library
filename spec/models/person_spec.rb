# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  birth_year  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Person do

  let(:person) { Person.new }

  subject { person }

  it 'should respond to a few properties' do
    %w(
      first_name
      middle_name
      last_name
      birth_year
      roles
      titles
      from_xml
    ).each { |property| person.should respond_to property.to_sym }
  end

end
