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

# Unit tests for KindeApi::OAuthApi
# Automatically generated by openapi-generator (https://openapi-generator.tech)
# Please update as you see appropriate
describe 'OAuthApi' do
  before do
    # run before each test
    @api_instance = KindeApi::OAuthApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of OAuthApi' do
    it 'should create an instance of OAuthApi' do
      expect(@api_instance).to be_instance_of(KindeApi::OAuthApi)
    end
  end

  # unit tests for get_user
  # Get User Profile
  # Contains the id, names and email of the currently logged in user.
  # @param [Hash] opts the optional parameters
  # @return [UserProfile]
  describe 'get_user test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for get_user_profile_v2
  # Returns the details of the currently logged in user
  # Contains the id, names, profile picture URL and email of the currently logged in user.
  # @param [Hash] opts the optional parameters
  # @return [UserProfileV2]
  describe 'get_user_profile_v2 test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for token_introspection
  # Get token details
  # Retrieve information about the provided token.
  # @param [Hash] opts the optional parameters
  # @option opts [String] :token The token to be introspected.
  # @option opts [String] :token_type The provided token&#39;s type.
  # @return [TokenIntrospect]
  describe 'token_introspection test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end

  # unit tests for token_revocation
  # Revoke token
  # Revoke a previously issued token.
  # @param [Hash] opts the optional parameters
  # @option opts [String] :token The token to be revoked.
  # @option opts [String] :client_id The identifier for your client.
  # @option opts [String] :client_secret The secret associated with your client.
  # @return [nil]
  describe 'token_revocation test' do
    it 'should work' do
      # assertion here. ref: https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/
    end
  end
end
