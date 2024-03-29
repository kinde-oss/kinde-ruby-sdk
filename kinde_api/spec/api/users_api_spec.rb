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

# Unit tests for KindeApi::UsersApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'UsersApi' do
  before do
    # run before each test
    @api_instance = KindeApi::UsersApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of UsersApi' do
    it 'should create an instance of UsersApi' do
      expect(@api_instance).to be_instance_of(KindeApi::UsersApi)
    end
  end

  # unit tests for create_user
  # Create User
  # Creates a user record and optionally zero or more identities for the user. An example identity could be the email address of the user.
  # @param [Hash] opts the optional parameters
  # @option opts [CreateUserRequest] :create_user_request The details of the user to create.
  # @return [CreateUserResponse]
  describe 'create_user test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for delete_user
  # Delete User
  # Delete a user record.
  # @param id The user&#39;s id.
  # @param [Hash] opts the optional parameters
  # @option opts [Boolean] :is_delete_profile Delete all data and remove the user&#39;s profile from all of Kinde, including the subscriber list
  # @return [SuccessResponse]
  describe 'delete_user test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for get_user_data
  # Get User
  # Retrieve a user record.
  # @param id The user&#39;s id.
  # @param [Hash] opts the optional parameters
  # @option opts [String] :expand Specify additional data to retrieve. Use \&quot;organizations\&quot; and/or \&quot;identities\&quot;.
  # @return [User]
  describe 'get_user_data test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for get_users
  # List Users
  # The returned list can be sorted by full name or email address in ascending or descending order. The number of records to return at a time can also be controlled using the &#x60;page_size&#x60; query string parameter.
  # @param [Hash] opts the optional parameters
  # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
  # @option opts [String] :user_id ID of the user to filter by.
  # @option opts [String] :next_token A string to get the next page of results if there are more results.
  # @option opts [String] :email Filter the results by email address. The query string should be comma separated and url encoded.
  # @option opts [String] :expand Specify additional data to retrieve. Use \&quot;organizations\&quot; and/or \&quot;identities\&quot;.
  # @return [UsersResponse]
  describe 'get_users test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for refresh_user_claims
  # Refresh User Claims and Invalidate Cache
  # Refreshes the user&#39;s claims and invalidates the current cache.
  # @param user_id The id of the user whose claims needs to be updated.
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'refresh_user_claims test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for update_user
  # Update User
  # Update a user record.
  # @param id The user&#39;s id.
  # @param update_user_request The user to update.
  # @param [Hash] opts the optional parameters
  # @return [UpdateUserResponse]
  describe 'update_user test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for update_user_feature_flag_override
  # Update User Feature Flag Override
  # Update user feature flag override.
  # @param user_id The identifier for the user
  # @param feature_flag_key The identifier for the feature flag
  # @param value Override value
  # @param [Hash] opts the optional parameters
  # @return [SuccessResponse]
  describe 'update_user_feature_flag_override test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end
end
