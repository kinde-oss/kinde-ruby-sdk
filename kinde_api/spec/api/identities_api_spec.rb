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

# Unit tests for KindeApi::IdentitiesApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'IdentitiesApi' do
  before do
    # run before each test
    @api_instance = KindeApi::IdentitiesApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of IdentitiesApi' do
    it 'should create an instance of IdentitiesApi' do
      expect(@api_instance).to be_instance_of(KindeApi::IdentitiesApi)
    end
  end

  # unit tests for delete_identity
  # Delete identity
  # Delete identity by ID.  &lt;div&gt;   &lt;code&gt;delete:identities&lt;/code&gt; &lt;/div&gt; 
  # @param identity_id The unique identifier for the identity.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'delete_identity test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for get_identity
  # Get identity
  # Returns an identity by ID  &lt;div&gt;   &lt;code&gt;read:identities&lt;/code&gt; &lt;/div&gt; 
  # @param identity_id The unique identifier for the identity.
  # @param [Hash] opts the optional parameters
  # @return [Identity]
  describe 'get_identity test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for update_identity
  # Update identity
  # Update identity by ID.  &lt;div&gt;   &lt;code&gt;update:identities&lt;/code&gt; &lt;/div&gt; 
  # @param identity_id The unique identifier for the identity.
  # @param update_identity_request The fields of the identity to update.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'update_identity test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end
