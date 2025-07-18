=begin
#Kinde Management API

# Provides endpoints to manage your Kinde Businesses.  ## Intro  ## How to use  1. [Set up and authorize a machine-to-machine (M2M) application](https://docs.kinde.com/developer-tools/kinde-api/connect-to-kinde-api/).  2. [Generate a test access token](https://docs.kinde.com/developer-tools/kinde-api/access-token-for-api/)  3. Test request any endpoint using the test token 

The version of the OpenAPI document: 1
Contact: support@kinde.com
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 6.4.0

=end

require 'cgi'

module KindeApi
  class BillingAgreementsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create billing agreement
    # Creates a new billing agreement based on the plan code passed, and cancels the customer's existing agreements  <div>   <code>create:billing_agreements</code> </div> 
    # @param create_billing_agreement_request [CreateBillingAgreementRequest] New agreement request values
    # @param [Hash] opts the optional parameters
    # @return [SuccessResponse]
    def create_billing_agreement(create_billing_agreement_request, opts = {})
      data, _status_code, _headers = create_billing_agreement_with_http_info(create_billing_agreement_request, opts)
      data
    end

    # Create billing agreement
    # Creates a new billing agreement based on the plan code passed, and cancels the customer&#39;s existing agreements  &lt;div&gt;   &lt;code&gt;create:billing_agreements&lt;/code&gt; &lt;/div&gt; 
    # @param create_billing_agreement_request [CreateBillingAgreementRequest] New agreement request values
    # @param [Hash] opts the optional parameters
    # @return [Array<(SuccessResponse, Integer, Hash)>] SuccessResponse data, response status code and response headers
    def create_billing_agreement_with_http_info(create_billing_agreement_request, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BillingAgreementsApi.create_billing_agreement ...'
      end
      # verify the required parameter 'create_billing_agreement_request' is set
      if @api_client.config.client_side_validation && create_billing_agreement_request.nil?
        fail ArgumentError, "Missing the required parameter 'create_billing_agreement_request' when calling BillingAgreementsApi.create_billing_agreement"
      end
      # resource path
      local_var_path = '/api/v1/billing/agreements'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(create_billing_agreement_request)

      # return_type
      return_type = opts[:debug_return_type] || 'SuccessResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"BillingAgreementsApi.create_billing_agreement",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BillingAgreementsApi#create_billing_agreement\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get billing agreements
    # Returns all the agreements a billing customer currently has access to  <div>   <code>read:billing_agreements</code> </div> 
    # @param customer_id [String] The ID of the billing customer to retrieve agreements for
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :starting_after The ID of the billing agreement to start after.
    # @option opts [String] :ending_before The ID of the billing agreement to end before.
    # @option opts [String] :feature_code The feature code to filter by agreements only containing that feature
    # @return [GetBillingAgreementsResponse]
    def get_billing_agreements(customer_id, opts = {})
      data, _status_code, _headers = get_billing_agreements_with_http_info(customer_id, opts)
      data
    end

    # Get billing agreements
    # Returns all the agreements a billing customer currently has access to  &lt;div&gt;   &lt;code&gt;read:billing_agreements&lt;/code&gt; &lt;/div&gt; 
    # @param customer_id [String] The ID of the billing customer to retrieve agreements for
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page_size Number of results per page. Defaults to 10 if parameter not sent.
    # @option opts [String] :starting_after The ID of the billing agreement to start after.
    # @option opts [String] :ending_before The ID of the billing agreement to end before.
    # @option opts [String] :feature_code The feature code to filter by agreements only containing that feature
    # @return [Array<(GetBillingAgreementsResponse, Integer, Hash)>] GetBillingAgreementsResponse data, response status code and response headers
    def get_billing_agreements_with_http_info(customer_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: BillingAgreementsApi.get_billing_agreements ...'
      end
      # verify the required parameter 'customer_id' is set
      if @api_client.config.client_side_validation && customer_id.nil?
        fail ArgumentError, "Missing the required parameter 'customer_id' when calling BillingAgreementsApi.get_billing_agreements"
      end
      # resource path
      local_var_path = '/api/v1/billing/agreements'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'customer_id'] = customer_id
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'starting_after'] = opts[:'starting_after'] if !opts[:'starting_after'].nil?
      query_params[:'ending_before'] = opts[:'ending_before'] if !opts[:'ending_before'].nil?
      query_params[:'feature_code'] = opts[:'feature_code'] if !opts[:'feature_code'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json; charset=utf-8', 'application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'GetBillingAgreementsResponse'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['kindeBearerAuth']

      new_options = opts.merge(
        :operation => :"BillingAgreementsApi.get_billing_agreements",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: BillingAgreementsApi#get_billing_agreements\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
