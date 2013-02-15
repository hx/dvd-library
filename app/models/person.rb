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
#  search_name :string(255)
#

class Person < ActiveRecord::Base

  xml_importer do
    map '@FirstName',    to: :first_name,     key: true
    map '@MiddleName',   to: :middle_name,    key: true
    map '@LastName',     to: :last_name,      key: true
    map '@BirthYear',    to: :birth_year,     key: true
  end

  attr_accessible :birth_year, :first_name, :last_name, :middle_name

  before_save :populate_search_name

  has_many :roles, include: :title
  has_many :titles, through: :roles

  extend FindByPartialName

  class << self
    alias_method :original_find_by_partial_name, :find_by_partial_name
  end

  #noinspection RailsChecklist04
  def self.find_by_partial_name(term, limit = nil)
    #noinspection RubyArgCount
    original_find_by_partial_name term.downcase.gsub(/[^a-z]/, ''), limit, :search_name
  end

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join ' '
  end

  def recent_work
    role = roles.joins(:title).order('release_date DESC').first
    role.job + ', ' + role.title.title
  end

  private

    def populate_search_name
      self.search_name = (first_name + middle_name + last_name + first_name).downcase.gsub(/[^a-z]/, '')
    end

end
