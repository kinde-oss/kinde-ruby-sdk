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

# Unit tests for KindeApi::ApplicationsApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'ApplicationsApi' do
  before do
    # run before each test
    @api_instance = KindeApi::ApplicationsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of ApplicationsApi' do
    it 'should create an instance of ApplicationsApi' do
      expect(@api_instance).to be_instance_of(KindeApi::ApplicationsApi)
    end
  end

  # unit tests for create_application
  # Create Application
  # Create an application.
  # @param [Hash] opts the optional parameters
  # @option opts [CreateApplicationRequest] :create_application_request Application details.
  # @return [CreateApplicationResponse]
  describe 'create_application test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for delete_application
  # Delete Application
  # Delete application.
  # @param application_id The identifier for the application.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'delete_application test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for get_application
  # Get Application
  # Gets an application given the application&#39;s id.
  # @param application_id The identifier for the application.
  # @param [Hash] opts the optional parameters
  # @return [GetApplicationResponse]
  describe 'get_application test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for get_applications
  # List Applications
  # Get a list of applications.
  # @param [Hash] opts the optional parameters
  # @option opts [String] :sort Field and order to sort the result by.
  # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
  # @option opts [String] :next_token A string to get the next page of results if there are more results.
  # @return [GetApplicationsResponse]
  describe 'get_applications test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for update_application
  # Update Application
  # Update an application.
  # @param application_id The identifier for the application.
  # @param [Hash] opts the optional parameters
  # @option opts [UpdateApplicationRequest] :update_application_request Application details.
  # @return [nil]
  describe 'update_application test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end
end
