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

class Role < ActiveRecord::Base

  xml_importer do
    map %w|@Role @CreditSubtype|,  to: :name
    map '@CreditType',             to: :department,   default: 'Cast'
  end

  attr_accessible :credit_type, :credited_as, :name, :uncredited, :voice, :title, :person

  belongs_to :title
  belongs_to :person

  scope :cast, where(department: 'Cast')

end
