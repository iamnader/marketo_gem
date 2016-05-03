require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Marketo
  describe LeadKeyType do
    it "should define the correct types" do
      expect(LeadKeyType::IDNUM).to eq 'IDNUM'
      expect(LeadKeyType::COOKIE).to eq 'COOKIE'
      expect(LeadKeyType::EMAIL).to eq 'EMAIL'
      expect(LeadKeyType::LEADOWNEREMAIL).to eq 'LEADOWNEREMAIL'
      expect(LeadKeyType::SFDCACCOUNTID).to eq 'SFDCACCOUNTID'
      expect(LeadKeyType::SFDCCONTACTID).to eq 'SFDCCONTACTID'
      expect(LeadKeyType::SFDCLEADID).to eq 'SFDCLEADID'
      expect(LeadKeyType::SFDCLEADOWNERID).to eq 'SFDCLEADOWNERID'
      expect(LeadKeyType::SFDCOPPTYID).to eq 'SFDCOPPTYID'
    end
  end

  describe LeadKey do
    it "should store type and value on construction" do
      KEY_VALUE = 'a value'
      KEY_TYPE = LeadKeyType::IDNUM
      lead_key = LeadKey.new(KEY_TYPE, KEY_VALUE)
      expect(lead_key.key_type).to eq KEY_TYPE
      expect(lead_key.key_value).to eq KEY_VALUE
    end

    it "should to_hash correctly" do
      KEY_VALUE = 'a value'
      KEY_TYPE = LeadKeyType::IDNUM
      lead_key = LeadKey.new(KEY_TYPE, KEY_VALUE)

      expect(lead_key.to_hash).to eq(:key_type => KEY_TYPE,
                                     :key_value => KEY_VALUE)
    end
  end
end
