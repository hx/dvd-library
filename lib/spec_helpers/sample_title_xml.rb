SAMPLE_TITLE_XML = <<-XML
<DVD>
  <ID>SAMPLE_TITLE.2</ID>
  <Title>The Quick &amp; the Dead</Title>
  <SortTitle>Quick &amp; the Dead, The</SortTitle>
  <UPC>123-456-789</UPC>
  <MediaTypes>
    <DVD>true</DVD>
    <HDDVD>false</HDDVD>
    <BluRay>true</BluRay>
  </MediaTypes>
  <ProductionYear>1999</ProductionYear>
  <Released>2005-02-08</Released>
  <RunningTime>93</RunningTime>
  <Overview>Gun slingin&apos;</Overview>
  <Rating>M</Rating>
  <Genres>
    <Genre>Action</Genre>
    <Genre>Western</Genre>
  </Genres>
  <Actors>
    <Actor FirstName="Russell" MiddleName="" LastName="Crowe" BirthYear="0" Role="Cort" CreditedAs="" Voice="false" Uncredited="false"/>
    <Actor FirstName="Leonardo" MiddleName="" LastName="DiCaprio" BirthYear="1974" Role="Kid" CreditedAs="" Voice="false" Uncredited="false"/>
  </Actors>
  <Credits>
    <Credit FirstName="Sam" MiddleName="" LastName="Raimi" BirthYear="0" CreditType="Direction" CreditSubtype="Director" CreditedAs=""/>
  </Credits>
  <Studios>
    <Studio>Columbia</Studio>
    <Studio>Tristar</Studio>
  </Studios>
  <BoxSet>
    <Parent>SAMPLE_PARENT.2</Parent>
    <Contents>
      <Content>SAMPLE_CHILD.2</Content>
    </Contents>
  </BoxSet>
</DVD>
XML

SAMPLE_CHILD_XML = <<-XML
<DVD>
  <ID>SAMPLE_CHILD.2</ID>
  <Title>Quick/Dead Special Features</Title>
  <BoxSet>
    <Parent>SAMPLE_TITLE.2</Parent>
    <Contents/>
  </BoxSet>
</DVD>
XML

SAMPLE_PARENT_XML = <<-XML
<DVD>
  <ID>SAMPLE_PARENT.2</ID>
  <Title>Quick/Dead Special Features</Title>
  <BoxSet>
    <Parent/>
    <Contents>
      <Content>SAMPLE_TITLE.2</Content>
    </Contents>
  </BoxSet>
</DVD>
XML

