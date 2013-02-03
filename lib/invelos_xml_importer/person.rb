module InvelosXmlImporter
  class Person < Base

    map '@FirstName',    to: :first_name,     key: true
    map '@MiddleName',   to: :middle_name,    key: true
    map '@LastName',     to: :last_name,      key: true
    map '@BirthYear',    to: :birth_year,     key: true

  end
end