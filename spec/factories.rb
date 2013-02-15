class Cyclic < Array
  def self.[](*args); new.push *args end
  def self.from(array); self[*array] end
  def [](index); super index % size  end
end

FactoryGirl.define do

  factory :library

  factory :genre do
    sequence(:name) do |n|
      genres = Cyclic.from %w[Action Adventure Comedy Romance Drama Animation Television Children Documentary]
      genres[n] + n.to_s
    end
  end

  factory :studio do
    sequence(:name) do |n|
      adj =  Cyclic['21st Century', 'New Line', 'Universal', 'Premiere']
      noun = Cyclic['Fox', 'Cinema', 'Pictures', 'Movies', 'Films']
      suf =  Cyclic.from %w[Co Inc Limited Entertainment International LLC]
      [adj[n], noun[n], suf[n], n.to_s].join ' '
    end
  end

  factory :media_type do
    sequence(:name) { |n| "Type #{n}" }
  end

  factory :person do
    first_name  'Fred'
    middle_name 'Jim'
    last_name   'Smith'
    birth_year  1950
  end

  factory :title do

    library

    barcode         '9321456987456'
    title           'The Quick & the Dead'
    overview        'Something with guns and closeups of eyebrows and boobs and rain and mud and stuff.'
    sort_title      'Quick & the Dead, The'
    production_year 1993
    release_date    20.years.ago
    runtime         91
    certification   'M'
    vendor_id       'abc123456'

    trait :with_genres do
      after(:create) do |title, e|
        title.genres << FactoryGirl.build_list(:genre, 3)
      end
    end

    trait :with_studios do
      after(:create) do |title, e|
        title.studios << FactoryGirl.build_list(:studio, 2)
      end
    end

    trait :with_media_types do
      after(:create) do |title, e|
        title.media_types << FactoryGirl.build_list(:media_type, 2)
      end
    end

  end
end