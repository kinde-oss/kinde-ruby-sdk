=begin
#Kinde Management API

#Provides endpoints to manage your Kinde Businesses

The version of the OpenAPI document: 1
Contact: support@kinde.com
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 6.4.0

=end

require 'spec_helper'
require 'json'

# Unit tests for KindeApi::EnvironmentsApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'EnvironmentsApi' do
  before do
    # run before each test
    @api_instance = KindeApi::EnvironmentsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of EnvironmentsApi' do
    it 'should create an instance of EnvironmentsApi' do
      expect(@api_instance).to be_instance_of(KindeApi::EnvironmentsApi)
    end
  end

  # unit tests for delete_environement_feature_flag_override
  # Delete environment feature flag override
  # Delete environment feature flag override.
  # @param feature_flag_key The identifier for the feature flag.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'delete_environement_feature_flag_override test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for delete_environement_feature_flag_overrides
  # Delete all environment feature flag overrides
  # Delete all environment feature flag overrides.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'delete_environement_feature_flag_overrides test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

  # unit tests for update_environement_feature_flag_override
  # Update environment feature flag override
  # Update environment feature flag override.
  # @param feature_flag_key The identifier for the feature flag.
  # @param value The override value for the feature flag.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'update_environement_feature_flag_override test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end