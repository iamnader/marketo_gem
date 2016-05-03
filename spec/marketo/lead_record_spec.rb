require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Marketo
  EMAIL = 'some@email.com'
  IDNUM    = 93480938

  describe LeadRecord do
    it "should store the idnum" do
      lead_record = LeadRecord.new(EMAIL, IDNUM)
      expect(lead_record.idnum).to eq IDNUM
    end

    it "should store the email" do
      expect(LeadRecord.new(EMAIL, IDNUM).email).to eq EMAIL
    end

    it "should implement == sensibly" do
      lead_record1 = LeadRecord.new(EMAIL, IDNUM)
      lead_record1.set_attribute('favourite color', 'red')
      lead_record1.set_attribute('age', '100')

      lead_record2 = LeadRecord.new(EMAIL, IDNUM)
      lead_record2.set_attribute('favourite color', 'red')
      lead_record2.set_attribute('age', '100')

      expect(lead_record1).to eq lead_record2
    end

    it "should store when attributes are set" do
      lead_record = LeadRecord.new(EMAIL, IDNUM)
      lead_record.set_attribute('favourite color', 'red')
      expect(lead_record.get_attribute('favourite color')).to eq 'red'
    end

    it "should store when attributes are updated" do
      lead_record = LeadRecord.new(EMAIL, IDNUM)
      lead_record.set_attribute('favourite color', 'red')
      lead_record.set_attribute('favourite color', 'green')
      expect(lead_record.get_attribute('favourite color')).to eq 'green'
    end

    it "should yield all attributes through each_attribute_pair" do
      lead_record = LeadRecord.new(EMAIL, IDNUM)
      lead_record.set_attribute('favourite color', 'red')
      lead_record.set_attribute('favourite color', 'green')
      lead_record.set_attribute('age', '99')

      pairs       = []
      lead_record.each_attribute_pair do |attribute_name, attribute_value|
        pairs << [attribute_name, attribute_value]
      end

      expect(pairs.size).to eq 3
      expect(pairs).to include(['favourite color', 'green'])
      expect(pairs).to include(['age', '99'])
      expect(pairs).to include(['Email', EMAIL])
    end

    it "should be instantiable from a savon hash" do
      savon_hash = {
        :email => EMAIL,
        :foreign_sys_type => nil,
        :lead_attribute_list => {
          :attribute => [
            { :attr_name => 'Company', :attr_type => 'string', :attr_value => 'Rapleaf'},
            { :attr_name => 'FirstName', :attr_type => 'string', :attr_value => 'James'},
            { :attr_name => 'LastName', :attr_type => 'string', :attr_value => 'O\'Brien'}
          ]
        },
        :foreign_sys_person_id => nil,
        :id => IDNUM
      }

      actual = LeadRecord.from_hash(savon_hash)

      expected = LeadRecord.new(EMAIL, IDNUM)
      expected.set_attribute('Company', 'Rapleaf')
      expected.set_attribute('FirstName', 'James')
      expected.set_attribute('LastName', 'O\'Brien')

      expect(actual).to eq expected
    end
  end
end
