# == Schema Information
#
# Table name: studio_involvements
#
#  id         :integer          not null, primary key
#  studio_id  :integer
#  title_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe StudioInvolvement do

  let(:title) { Title.from_xml SAMPLE_TITLE_XML }

  specify { title.studio_involvements.count.should == 2 }

end
