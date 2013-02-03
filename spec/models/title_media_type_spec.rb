# == Schema Information
#
# Table name: title_media_types
#
#  id            :integer          not null, primary key
#  title_id      :integer
#  media_type_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe TitleMediaType do

  let(:title) { Title.from_xml SAMPLE_TITLE_XML }

  specify { title.title_media_types.count.should == 2 }

end
