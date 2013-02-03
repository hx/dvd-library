# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Genre do

  let(:title) { Title.from_xml SAMPLE_TITLE_XML }

  specify { title.genres.map(&:name).sort.should == %w|Action Western| }

end
