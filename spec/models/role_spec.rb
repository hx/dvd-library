# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  title_id    :integer
#  person_id   :integer
#  name        :string(255)
#  department  :string(255)
#  credited_as :string(255)
#  uncredited  :boolean
#  voice       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Role do

  let(:role) { Role.new }

  subject { role }

  it 'should respond to a few properties' do
    %w(
      title
      person
      name
      department
      credited_as
      uncredited
      voice
    ).each { |property| role.should respond_to property.to_sym }
  end

end
