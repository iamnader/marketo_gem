require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Marketo
  ACCESS_KEY = 'ACCESS_KEY'
  SECRET_KEY = 'SECRET_KEY'

  describe AuthenticationHeader do
    it "should set mktowsUserId to access key" do
      header = Marketo::AuthenticationHeader.new(ACCESS_KEY, SECRET_KEY)
      expect(header.get_mktows_user_id).to eq ACCESS_KEY
    end

    it "should set requestSignature" do
      header = Marketo::AuthenticationHeader.new(ACCESS_KEY, SECRET_KEY)
      expect(header.get_request_signature).to_not be_nil
      expect(header.get_request_signature).to_not eq ""
    end

    it "should set requestTimestamp in correct format" do
      header = Marketo::AuthenticationHeader.new(ACCESS_KEY, SECRET_KEY)
      time   = DateTime.new(1998, 1, 17, 20, 15, 1)
      header.set_time(time)
      expect(header.get_request_timestamp).to eq "1998-01-17T20:15:01+00:00"
    end

    it "should calculate encrypted signature" do
      # I got this example of the marketo API docs

      access_key = 'bigcorp1_461839624B16E06BA2D663'
      secret_key = '899756834129871744AAEE88DDCC77CDEEDEC1AAAD66'

      header     = Marketo::AuthenticationHeader.new(access_key, secret_key)
      header.set_time(DateTime.new(2010, 4, 9, 14, 4, 54, -7/24.0))

      expect(header.get_request_timestamp).to eq "2010-04-09T14:04:54-07:00"
      expect(header.get_request_signature).to eq "ffbff4d4bef354807481e66dc7540f7890523a87"
    end

    it "should cope if no date is given" do
      header   = Marketo::AuthenticationHeader.new(ACCESS_KEY, SECRET_KEY)
      expected = DateTime.now
      actual   = DateTime.parse(header.get_request_timestamp)

      expect(expected.year).to eq actual.year
      expect(expected.hour).to eq actual.hour
    end

    it "should to_hash correctly" do
      # I got this example from the marketo API docs

      access_key = 'bigcorp1_461839624B16E06BA2D663'
      secret_key = '899756834129871744AAEE88DDCC77CDEEDEC1AAAD66'

      header     = Marketo::AuthenticationHeader.new(access_key, secret_key)
      header.set_time(DateTime.new(2010, 4, 9, 14, 4, 55, -7/24.0))

      expect(header.to_hash).to eq(
                                  "mktowsUserId"     => header.get_mktows_user_id,
                                  "requestSignature" => header.get_request_signature,
                                  "requestTimestamp" => header.get_request_timestamp,
                                )
    end
  end
end
