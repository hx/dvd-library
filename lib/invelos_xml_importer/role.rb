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

module InvelosXmlImporter
  class Role < Base

    map %w|@Role @CreditSubtype|,  to: :name
    map '@CreditType',             to: :department,   default: 'Cast'

  end
end
