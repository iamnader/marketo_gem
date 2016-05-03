require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Marketo

  describe Client do
    EMAIL   = "some@email.com"
    IDNUM   = 29
    FIRST   = 'Joe'
    LAST    = 'Smith'
    COMPANY = 'Rapleaf'
    MOBILE  = '415 123 456'
    API_KEY = 'API123KEY'

    context 'Exception handling' do
      it "should return nil if any exception is raised on get_lead request" do
        savon_client          = double('savon_client').as_null_object
        authentication_header = double('authentication_header').as_null_object
        client                = Marketo::Client.new(savon_client, authentication_header)
        expect(savon_client).to receive(:request).and_raise Exception
        expect(client.get_lead_by_email(EMAIL)).to be_nil
      end

      it "should return nil if any exception is raised on sync_lead request" do
        savon_client          = double('savon_client').as_null_object
        authentication_header = double('authentication_header').as_null_object
        client                = Marketo::Client.new(savon_client, authentication_header)
        expect(savon_client).to receive(:request).and_raise Exception
        expect(client.sync_lead(EMAIL, FIRST, LAST, COMPANY, MOBILE)).to be_nil
      end
    end

    context 'Client interaction' do
      it "should have the correct body format on get_lead_by_idnum" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Marketo::Client.new(savon_client, authentication_header)
        response_hash         = {
          :success_get_lead => {
            :result => {
              :count            => 1,
              :lead_record_list => {
                :lead_record => {
                  :email                 => EMAIL,
                  :lead_attribute_list   => {
                    :attribute => [
                      {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                      {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                      {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                      {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                    ]
                  },
                  :foreign_sys_type      => nil,
                  :foreign_sys_person_id => nil,
                  :id                    => IDNUM.to_s
                }
              }
            }
          }
        }
        expect_request(savon_client,
                       authentication_header,
                       equals_matcher(:lead_key => {
                         :key_value => IDNUM,
                         :key_type  => LeadKeyType::IDNUM
                       }),
                       'ns1:paramsGetLead',
                       response_hash)
        expected_lead_record = LeadRecord.new(EMAIL, IDNUM)
        expected_lead_record.set_attribute('name1', 'val1')
        expected_lead_record.set_attribute('name2', 'val2')
        expected_lead_record.set_attribute('name3', 'val3')
        expected_lead_record.set_attribute('name4', 'val4')
        expect(client.get_lead_by_idnum(IDNUM)).to eq expected_lead_record
      end

      it "should have the correct body format on get_lead_by_email" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Marketo::Client.new(savon_client, authentication_header)
        response_hash         = {
          :success_get_lead => {
            :result => {
              :count            => 1,
              :lead_record_list => {
                :lead_record => {
                  :email                 => EMAIL,
                  :lead_attribute_list   => {
                    :attribute => [
                      {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                      {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                      {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                      {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                    ]
                  },
                  :foreign_sys_type      => nil,
                  :foreign_sys_person_id => nil,
                  :id                    => IDNUM.to_s
                }
              }
            }
          }
        }
        expect_request(savon_client,
                       authentication_header,
                       equals_matcher({:lead_key => {
                         :key_value => EMAIL,
                         :key_type  => LeadKeyType::EMAIL}}),
                       'ns1:paramsGetLead',
                       response_hash)
        expected_lead_record = LeadRecord.new(EMAIL, IDNUM)
        expected_lead_record.set_attribute('name1', 'val1')
        expected_lead_record.set_attribute('name2', 'val2')
        expected_lead_record.set_attribute('name3', 'val3')
        expected_lead_record.set_attribute('name4', 'val4')
        expect(client.get_lead_by_email(EMAIL)).to eq expected_lead_record
      end

      it "should have the correct body format on sync_lead_record" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Marketo::Client.new(savon_client, authentication_header)
        response_hash         = {
          :success_sync_lead => {
            :result => {
              :lead_id     => IDNUM,
              :sync_status => {
                :error   => nil,
                :status  => 'UPDATED',
                :lead_id => IDNUM
              },
              :lead_record => {
                :email                 => EMAIL,
                :lead_attribute_list   => {
                  :attribute => [
                    {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                    {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                    {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                    {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                  ]
                },
                :foreign_sys_type      => nil,
                :foreign_sys_person_id => nil,
                :id                    => IDNUM.to_s
              }
            }
          }
        }
        expect_request(savon_client,
                       authentication_header,
                       (Proc.new do |actual|
                         retval = true
                         retval = false unless actual[:return_lead]
                         retval = false unless actual[:lead_record][:email].equal?(EMAIL)
                         retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].size == 5
                         retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => EMAIL, :attr_name => "Email", :attr_type => "string"})
                         retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val1", :attr_name => "name1", :attr_type => "string"})
                         retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val2", :attr_name => "name2", :attr_type => "string"})
                         retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val3", :attr_name => "name3", :attr_type => "string"})
                         retval = false unless actual[:lead_record][:lead_attribute_list][:attribute].include?({:attr_value => "val4", :attr_name => "name4", :attr_type => "string"})
                         expect(retval).to be true
                       end),
                       'ns1:paramsSyncLead',
                       response_hash)
        lead_record = LeadRecord.new(EMAIL, IDNUM)
        lead_record.set_attribute('name1', 'val1')
        lead_record.set_attribute('name2', 'val2')
        lead_record.set_attribute('name3', 'val3')
        lead_record.set_attribute('name4', 'val4')

        expect(client.sync_lead_record(lead_record)).to eq lead_record
      end

      it "should have the correct body format on sync_lead" do
        savon_client          = double('savon_client')
        authentication_header = double('authentication_header')
        client                = Marketo::Client.new(savon_client, authentication_header)
        response_hash         = {
          :success_sync_lead => {
            :result => {
              :lead_id     => IDNUM,
              :sync_status => {
                :error   => nil,
                :status  => 'UPDATED',
                :lead_id => IDNUM
              },
              :lead_record => {
                :email                 => EMAIL,
                :lead_attribute_list   => {
                  :attribute => [
                    {:attr_name => 'name1', :attr_type => 'string', :attr_value => 'val1'},
                    {:attr_name => 'name2', :attr_type => 'string', :attr_value => 'val2'},
                    {:attr_name => 'name3', :attr_type => 'string', :attr_value => 'val3'},
                    {:attr_name => 'name4', :attr_type => 'string', :attr_value => 'val4'}
                  ]
                },
                :foreign_sys_type      => nil,
                :foreign_sys_person_id => nil,
                :id                    => IDNUM.to_s
              }
            }
          }
        }

        expect_request(savon_client,
                       authentication_header,
                       Proc.new { |actual|
                         actual_attribute_list                                  = actual[:lead_record][:lead_attribute_list][:attribute]
                         actual[:lead_record][:lead_attribute_list][:attribute] = nil
                         expected                                               = {
                           :return_lead => true,
                           :lead_record => {
                             :email               => "some@email.com",
                             :lead_attribute_list =>
                               {
                                 :attribute => nil}}
                         }
                         expect(actual).to eq expected
                         expect(actual_attribute_list).to include(
                                                            {:attr_value => FIRST,
                                                             :attr_name  => "FirstName",
                                                             :attr_type  => "string"},
                                                            {:attr_value => LAST,
                                                             :attr_name  => "LastName",
                                                             :attr_type  => "string"},
                                                            {:attr_value => EMAIL,
                                                             :attr_name  =>"Email",
                                                             :attr_type  => "string"},
                                                            {:attr_value => COMPANY,
                                                             :attr_name  => "Company",
                                                             :attr_type  => "string"},
                                                            {:attr_value => MOBILE,
                                                             :attr_name  => "MobilePhone",
                                                             :attr_type  => "string"}
                                                          )
                       },
                       'ns1:paramsSyncLead',
                       response_hash)
        expected_lead_record = LeadRecord.new(EMAIL, IDNUM)
        expected_lead_record.set_attribute('name1', 'val1')
        expected_lead_record.set_attribute('name2', 'val2')
        expected_lead_record.set_attribute('name3', 'val3')
        expected_lead_record.set_attribute('name4', 'val4')
        expect(client.sync_lead(EMAIL, FIRST, LAST, COMPANY, MOBILE)).to eq expected_lead_record
      end

      context "list operations" do
        LIST_KEY = 'awesome leads list'

        before(:each) do
          @savon_client          = double('savon_client')
          @authentication_header = double('authentication_header')
          @client                = Marketo::Client.new(@savon_client, @authentication_header)
        end

        it "should have the correct body format on add_to_list" do
          response_hash = {} # TODO
          expect_request(@savon_client,
                         @authentication_header,
                         equals_matcher({
                                          :list_operation   => ListOperationType::ADD_TO,
                                          :list_key         => LIST_KEY,
                                          :strict           => 'false',
                                          :list_member_list => {
                                            :lead_key => [
                                              {
                                                :key_type  => 'EMAIL',
                                                :key_value => EMAIL
                                              }
                                            ]
                                          }
                                        }),
                         'ns1:paramsListOperation',
                         response_hash)

          expect(@client.add_to_list(LIST_KEY, EMAIL)).to eq response_hash
        end

        it "should have the correct body format on remove_from_list" do
          response_hash = {} # TODO
          expect_request(@savon_client,
                         @authentication_header,
                         equals_matcher({
                                          :list_operation   => ListOperationType::REMOVE_FROM,
                                          :list_key         => LIST_KEY,
                                          :strict           => 'false',
                                          :list_member_list => {
                                            :lead_key => [
                                              {
                                                :key_type  => 'EMAIL',
                                                :key_value => EMAIL
                                              }
                                            ]
                                          }
                                        }),
                         'ns1:paramsListOperation',
                         response_hash)

          expect(@client.remove_from_list(LIST_KEY, EMAIL)).to eq response_hash
        end

        it "should have the correct body format on is_member_of_list?" do
          response_hash = {} # TODO
          expect_request(@savon_client,
                         @authentication_header,
                         equals_matcher({
                                          :list_operation   => ListOperationType::IS_MEMBER_OF,
                                          :list_key         => LIST_KEY,
                                          :strict           => 'false',
                                          :list_member_list => {
                                            :lead_key => [
                                              {
                                                :key_type  => 'EMAIL',
                                                :key_value => EMAIL
                                              }
                                            ]
                                          }
                                        }),
                         'ns1:paramsListOperation',
                         response_hash)

          expect(@client.is_member_of_list?(LIST_KEY, EMAIL)).to eq response_hash
        end
      end
    end

    private

    def equals_matcher(expected)
      Proc.new { |actual|
        expect(actual).to eq expected
      }
    end

    def expect_request(savon_client, authentication_header, expected_body_matcher, expected_namespace, response_hash)
      header_hash       = double('header_hash')
      soap_response     = double('soap_response')
      request_namespace = double('namespace')
      request_header    = double('request_header')
      soap_request      = double('soap_request')
      expect(authentication_header).to receive(:set_time)
      expect(authentication_header).to receive(:to_hash).and_return(header_hash)
      expect(request_namespace).to receive(:[]=).with("xmlns:ns1", "http://www.marketo.com/mktows/")
      expect(request_header).to receive(:[]=).with("ns1:AuthenticationHeader", header_hash)
      expect(soap_request).to receive(:namespaces).and_return(request_namespace)
      expect(soap_request).to receive(:header).and_return(request_header)
      expect(soap_request).to receive(:body=) do |actual_body|
        expected_body_matcher.call(actual_body)
      end
      expect(soap_response).to receive(:to_hash).and_return(response_hash)
      expect(savon_client).to receive(:request).with(expected_namespace).and_yield(soap_request).and_return(soap_response)
    end
  end

  describe ListOperationType do
    it 'should define the correct types' do
      expect(ListOperationType::ADD_TO).to eq 'ADDTOLIST'
      expect(ListOperationType::IS_MEMBER_OF).to eq 'ISMEMBEROFLIST'
      expect(ListOperationType::REMOVE_FROM).to eq 'REMOVEFROMLIST'
    end
  end
end
