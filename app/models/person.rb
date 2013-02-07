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

class Person < ActiveRecord::Base

  xml_importer do
    map '@FirstName',    to: :first_name,     key: true
    map '@MiddleName',   to: :middle_name,    key: true
    map '@LastName',     to: :last_name,      key: true
    map '@BirthYear',    to: :birth_year,     key: true
  end

  attr_accessible :birth_year, :first_name, :last_name, :middle_name

  has_many :roles, include: :title
  has_many :titles, through: :roles

end
