# frozen_string_literal: true

# #Kinde Management API
#
# Provides endpoints to manage your Kinde Businesses
#
# The version of the OpenAPI document: 1
# Contact: support@kinde.com
# Generated by: https://openapi-generator.tech
# OpenAPI Generator version: 7.0.0-SNAPSHOT
#

require 'spec_helper'
require 'json'

# Unit tests for KindeApi::IndustriesApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'IndustriesApi' do
  before do
    # run before each test
    @api_instance = KindeApi::IndustriesApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of IndustriesApi' do
    it 'should create an instance of IndustriesApi' do
      expect(@api_instance).to be_instance_of(KindeApi::IndustriesApi)
    end
  end

  # unit tests for get_industries
  # List industries and industry keys.
  # Get a list of industries and associated industry keys.
  # @param [Hash] opts the optional parameters
  # @option opts [String] :industry_key Industry Key.
  # @option opts [String] :name Industry name.
  # @return [SuccessResponse]
  describe 'get_industries test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end
end
