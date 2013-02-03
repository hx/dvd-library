# == Schema Information
#
# Table name: titles
#
#  id              :integer          not null, primary key
#  barcode         :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  overview        :text
#  sort_title      :string(255)
#  production_year :integer
#  release_date    :date
#  runtime         :integer
#  certification   :string(255)
#

require 'spec_helper'

describe Title do

  let(:title) { Title.new }

  subject { title }

  it 'should respond to a few methods' do
    %w|
      id
      barcode
      title
      overview
      sort_title
      production_year
      release_date
      runtime
      certification
      roles
      people
    |.each { |w| title.should respond_to w.to_sym }
  end

end

