# == Schema Information
#
# Table name: studios
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Studio do

  let(:title) { Title.from_xml SAMPLE_TITLE_XML }

  specify { title.studios.map(&:name).sort.should == %w|Columbia Tristar| }

end
