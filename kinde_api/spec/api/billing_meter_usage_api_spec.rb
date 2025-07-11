=begin
#Kinde Management API

# Provides endpoints to manage your Kinde Businesses.  ## Intro  ## How to use  1. [Set up and authorize a machine-to-machine (M2M) application](https://docs.kinde.com/developer-tools/kinde-api/connect-to-kinde-api/).  2. [Generate a test access token](https://docs.kinde.com/developer-tools/kinde-api/access-token-for-api/)  3. Test request any endpoint using the test token 

The version of the OpenAPI document: 1
Contact: support@kinde.com
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 6.4.0

=end

require 'spec_helper'
require 'json'

# Unit tests for KindeApi::BillingMeterUsageApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'BillingMeterUsageApi' do
  before do
    # run before each test
    @api_instance = KindeApi::BillingMeterUsageApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of BillingMeterUsageApi' do
    it 'should create an instance of BillingMeterUsageApi' do
      expect(@api_instance).to be_instance_of(KindeApi::BillingMeterUsageApi)
    end
  end

  # unit tests for create_meter_usage_record
  # Create meter usage record
  # Create a new meter usage record  &lt;div&gt;   &lt;code&gt;create:meter_usage&lt;/code&gt; &lt;/div&gt; 
  # @param create_meter_usage_record_request Meter usage record
  # @param [Hash] opts the optional parameters
  # @return [CreateMeterUsageRecordResponse]
  describe 'create_meter_usage_record test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
