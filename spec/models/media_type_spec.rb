# == Schema Information
#
# Table name: media_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe MediaType do

  let(:title) { Title.from_xml SAMPLE_TITLE_XML }

  specify { title.media_types.map(&:name).sort.should == %w|BluRay DVD| }

end
