## Getting Started

```ruby
# Load the gem
require 'kinde_api'

# Setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
  # Configure a proc to get access tokens in lieu of the static access_token configuration
  config.access_token_getter = -> { 'YOUR TOKEN GETTER PROC' } 
end

api_instance = KindeApi::APIsApi.new
add_apis_request = KindeApi::AddAPIsRequest.new({name: 'name_example', audience: 'audience_example'}) # AddAPIsRequest | API details.

begin
  #Add APIs
  result = api_instance.add_apis(add_apis_request)
  p result
rescue KindeApi::ApiError => e
  puts "Exception when calling APIsApi->add_apis: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://app.kinde.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*KindeApi::APIsApi* | [**add_apis**](docs/APIsApi.md#add_apis) | **POST** /api/v1/apis | Add APIs
*KindeApi::APIsApi* | [**delete_api**](docs/APIsApi.md#delete_api) | **DELETE** /api/v1/apis/{api_id} | Delete API
*KindeApi::APIsApi* | [**get_api**](docs/APIsApi.md#get_api) | **GET** /api/v1/apis/{api_id} | List API details
*KindeApi::APIsApi* | [**get_apis**](docs/APIsApi.md#get_apis) | **GET** /api/v1/apis | List APIs
*KindeApi::APIsApi* | [**update_api_applications**](docs/APIsApi.md#update_api_applications) | **PATCH** /api/v1/apis/{api_id}/applications | Update API Applications
*KindeApi::ApplicationsApi* | [**create_application**](docs/ApplicationsApi.md#create_application) | **POST** /api/v1/applications | Create Application
*KindeApi::ApplicationsApi* | [**delete_application**](docs/ApplicationsApi.md#delete_application) | **DELETE** /api/v1/applications/{application_id} | Delete Application
*KindeApi::ApplicationsApi* | [**get_application**](docs/ApplicationsApi.md#get_application) | **GET** /api/v1/applications/{application_id} | Get Application
*KindeApi::ApplicationsApi* | [**get_applications**](docs/ApplicationsApi.md#get_applications) | **GET** /api/v1/applications | List Applications
*KindeApi::ApplicationsApi* | [**update_application**](docs/ApplicationsApi.md#update_application) | **PATCH** /api/v1/applications/{application_id} | Update Application
*KindeApi::BusinessApi* | [**get_business**](docs/BusinessApi.md#get_business) | **GET** /api/v1/business | List business details
*KindeApi::BusinessApi* | [**update_business**](docs/BusinessApi.md#update_business) | **PATCH** /api/v1/business | Update business details
*KindeApi::CallbacksApi* | [**add_logout_redirect_urls**](docs/CallbacksApi.md#add_logout_redirect_urls) | **POST** /api/v1/applications/{app_id}/auth_logout_urls | Add Logout Redirect URLs
*KindeApi::CallbacksApi* | [**add_redirect_callback_urls**](docs/CallbacksApi.md#add_redirect_callback_urls) | **POST** /api/v1/applications/{app_id}/auth_redirect_urls | Add Redirect Callback URLs
*KindeApi::CallbacksApi* | [**delete_callback_urls**](docs/CallbacksApi.md#delete_callback_urls) | **DELETE** /api/v1/applications/{app_id}/auth_redirect_urls | Delete Callback URLs
*KindeApi::CallbacksApi* | [**delete_logout_urls**](docs/CallbacksApi.md#delete_logout_urls) | **DELETE** /api/v1/applications/{app_id}/auth_logout_urls | Delete Logout URLs
*KindeApi::CallbacksApi* | [**get_callback_urls**](docs/CallbacksApi.md#get_callback_urls) | **GET** /api/v1/applications/{app_id}/auth_redirect_urls | List Callback URLs
*KindeApi::CallbacksApi* | [**get_logout_urls**](docs/CallbacksApi.md#get_logout_urls) | **GET** /api/v1/applications/{app_id}/auth_logout_urls | List Logout URLs
*KindeApi::CallbacksApi* | [**replace_logout_redirect_urls**](docs/CallbacksApi.md#replace_logout_redirect_urls) | **PUT** /api/v1/applications/{app_id}/auth_logout_urls | Replace Logout Redirect URLs
*KindeApi::CallbacksApi* | [**replace_redirect_callback_urls**](docs/CallbacksApi.md#replace_redirect_callback_urls) | **PUT** /api/v1/applications/{app_id}/auth_redirect_urls | Replace Redirect Callback URLs
*KindeApi::ConnectedAppsApi* | [**get_connected_app_auth_url**](docs/ConnectedAppsApi.md#get_connected_app_auth_url) | **GET** /api/v1/connected_apps/auth_url | Get Connected App URL
*KindeApi::ConnectedAppsApi* | [**get_connected_app_token**](docs/ConnectedAppsApi.md#get_connected_app_token) | **GET** /api/v1/connected_apps/token | Get Connected App Token
*KindeApi::ConnectedAppsApi* | [**revoke_connected_app_token**](docs/ConnectedAppsApi.md#revoke_connected_app_token) | **POST** /api/v1/connected_apps/revoke | Revoke Connected App Token
*KindeApi::EnvironmentsApi* | [**delete_environement_feature_flag_override**](docs/EnvironmentsApi.md#delete_environement_feature_flag_override) | **DELETE** /api/v1/environment/feature_flags/{feature_flag_key} | Delete Environment Feature Flag Override
*KindeApi::EnvironmentsApi* | [**delete_environement_feature_flag_overrides**](docs/EnvironmentsApi.md#delete_environement_feature_flag_overrides) | **DELETE** /api/v1/environment/feature_flags | Delete Environment Feature Flag Overrides
*KindeApi::EnvironmentsApi* | [**get_environement_feature_flags**](docs/EnvironmentsApi.md#get_environement_feature_flags) | **GET** /api/v1/environment/feature_flags | List Environment Feature Flags
*KindeApi::EnvironmentsApi* | [**update_environement_feature_flag_override**](docs/EnvironmentsApi.md#update_environement_feature_flag_override) | **PATCH** /api/v1/environment/feature_flags/{feature_flag_key} | Update Environment Feature Flag Override
*KindeApi::FeatureFlagsApi* | [**create_feature_flag**](docs/FeatureFlagsApi.md#create_feature_flag) | **POST** /api/v1/feature_flags | Create Feature Flag
*KindeApi::FeatureFlagsApi* | [**delete_feature_flag**](docs/FeatureFlagsApi.md#delete_feature_flag) | **DELETE** /api/v1/feature_flags/{feature_flag_key} | Delete Feature Flag
*KindeApi::FeatureFlagsApi* | [**update_feature_flag**](docs/FeatureFlagsApi.md#update_feature_flag) | **PUT** /api/v1/feature_flags/{feature_flag_key} | Replace Feature Flag
*KindeApi::IndustriesApi* | [**get_industries**](docs/IndustriesApi.md#get_industries) | **GET** /api/v1/industries | List industries and industry keys.
*KindeApi::OAuthApi* | [**get_user**](docs/OAuthApi.md#get_user) | **GET** /oauth2/user_profile | Get User Profile
*KindeApi::OAuthApi* | [**get_user_profile_v2**](docs/OAuthApi.md#get_user_profile_v2) | **GET** /oauth2/v2/user_profile | Returns the details of the currently logged in user
*KindeApi::OAuthApi* | [**token_introspection**](docs/OAuthApi.md#token_introspection) | **POST** /oauth2/introspect | Get token details
*KindeApi::OAuthApi* | [**token_revocation**](docs/OAuthApi.md#token_revocation) | **POST** /oauth2/revoke | Revoke token
*KindeApi::OrganizationsApi* | [**add_organization_users**](docs/OrganizationsApi.md#add_organization_users) | **POST** /api/v1/organizations/{org_code}/users | Add Organization Users
*KindeApi::OrganizationsApi* | [**create_organization**](docs/OrganizationsApi.md#create_organization) | **POST** /api/v1/organization | Create Organization
*KindeApi::OrganizationsApi* | [**create_organization_user_permission**](docs/OrganizationsApi.md#create_organization_user_permission) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/permissions | Add Organization User Permission
*KindeApi::OrganizationsApi* | [**create_organization_user_role**](docs/OrganizationsApi.md#create_organization_user_role) | **POST** /api/v1/organizations/{org_code}/users/{user_id}/roles | Add Organization User Role
*KindeApi::OrganizationsApi* | [**delete_organization**](docs/OrganizationsApi.md#delete_organization) | **DELETE** /api/v1/organization/{org_code} | Delete Organization
*KindeApi::OrganizationsApi* | [**delete_organization_feature_flag_override**](docs/OrganizationsApi.md#delete_organization_feature_flag_override) | **DELETE** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Delete Organization Feature Flag Override
*KindeApi::OrganizationsApi* | [**delete_organization_feature_flag_overrides**](docs/OrganizationsApi.md#delete_organization_feature_flag_overrides) | **DELETE** /api/v1/organizations/{org_code}/feature_flags | Delete Organization Feature Flag Overrides
*KindeApi::OrganizationsApi* | [**delete_organization_user_permission**](docs/OrganizationsApi.md#delete_organization_user_permission) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/permissions/{permission_id} | Delete Organization User Permission
*KindeApi::OrganizationsApi* | [**delete_organization_user_role**](docs/OrganizationsApi.md#delete_organization_user_role) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id}/roles/{role_id} | Delete Organization User Role
*KindeApi::OrganizationsApi* | [**get_organization**](docs/OrganizationsApi.md#get_organization) | **GET** /api/v1/organization | Get Organization
*KindeApi::OrganizationsApi* | [**get_organization_feature_flags**](docs/OrganizationsApi.md#get_organization_feature_flags) | **GET** /api/v1/organizations/{org_code}/feature_flags | List Organization Feature Flags
*KindeApi::OrganizationsApi* | [**get_organization_user_permissions**](docs/OrganizationsApi.md#get_organization_user_permissions) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/permissions | List Organization User Permissions
*KindeApi::OrganizationsApi* | [**get_organization_user_roles**](docs/OrganizationsApi.md#get_organization_user_roles) | **GET** /api/v1/organizations/{org_code}/users/{user_id}/roles | List Organization User Roles
*KindeApi::OrganizationsApi* | [**get_organization_users**](docs/OrganizationsApi.md#get_organization_users) | **GET** /api/v1/organizations/{org_code}/users | List Organization Users
*KindeApi::OrganizationsApi* | [**get_organizations**](docs/OrganizationsApi.md#get_organizations) | **GET** /api/v1/organizations | List Organizations
*KindeApi::OrganizationsApi* | [**remove_organization_user**](docs/OrganizationsApi.md#remove_organization_user) | **DELETE** /api/v1/organizations/{org_code}/users/{user_id} | Remove Organization User
*KindeApi::OrganizationsApi* | [**update_organization**](docs/OrganizationsApi.md#update_organization) | **PATCH** /api/v1/organization/{org_code} | Update Organization
*KindeApi::OrganizationsApi* | [**update_organization_feature_flag_override**](docs/OrganizationsApi.md#update_organization_feature_flag_override) | **PATCH** /api/v1/organizations/{org_code}/feature_flags/{feature_flag_key} | Update Organization Feature Flag Override
*KindeApi::OrganizationsApi* | [**update_organization_users**](docs/OrganizationsApi.md#update_organization_users) | **PATCH** /api/v1/organizations/{org_code}/users | Update Organization Users
*KindeApi::PermissionsApi* | [**create_permission**](docs/PermissionsApi.md#create_permission) | **POST** /api/v1/permissions | Create Permission
*KindeApi::PermissionsApi* | [**delete_permission**](docs/PermissionsApi.md#delete_permission) | **DELETE** /api/v1/permissions/{permission_id} | Delete Permission
*KindeApi::PermissionsApi* | [**get_permissions**](docs/PermissionsApi.md#get_permissions) | **GET** /api/v1/permissions | List Permissions
*KindeApi::PermissionsApi* | [**update_permissions**](docs/PermissionsApi.md#update_permissions) | **PATCH** /api/v1/permissions/{permission_id} | Update Permission
*KindeApi::RolesApi* | [**create_role**](docs/RolesApi.md#create_role) | **POST** /api/v1/role | Create Role
*KindeApi::RolesApi* | [**delete_role**](docs/RolesApi.md#delete_role) | **DELETE** /api/v1/roles/{role_id} | Delete Role
*KindeApi::RolesApi* | [**get_role_permission**](docs/RolesApi.md#get_role_permission) | **GET** /api/v1/roles/{role_id}/permissions | Get Role Permissions
*KindeApi::RolesApi* | [**get_roles**](docs/RolesApi.md#get_roles) | **GET** /api/v1/roles | List Roles
*KindeApi::RolesApi* | [**remove_role_permission**](docs/RolesApi.md#remove_role_permission) | **DELETE** /api/v1/roles/{role_id}/permissions/{permission_id} | Remove Role Permission
*KindeApi::RolesApi* | [**update_role_permissions**](docs/RolesApi.md#update_role_permissions) | **PATCH** /api/v1/roles/{role_id}/permissions | Update Role Permissions
*KindeApi::RolesApi* | [**update_roles**](docs/RolesApi.md#update_roles) | **PATCH** /api/v1/roles/{role_id} | Update Role
*KindeApi::SubscribersApi* | [**create_subscriber**](docs/SubscribersApi.md#create_subscriber) | **POST** /api/v1/subscribers | Create Subscriber
*KindeApi::SubscribersApi* | [**get_subscriber**](docs/SubscribersApi.md#get_subscriber) | **GET** /api/v1/subscribers/{subscriber_id} | Get Subscriber
*KindeApi::SubscribersApi* | [**get_subscribers**](docs/SubscribersApi.md#get_subscribers) | **GET** /api/v1/subscribers | List Subscribers
*KindeApi::TimezonesApi* | [**get_timezones**](docs/TimezonesApi.md#get_timezones) | **GET** /api/v1/timezones | List timezones and timezone IDs.
*KindeApi::UsersApi* | [**create_user**](docs/UsersApi.md#create_user) | **POST** /api/v1/user | Create User
*KindeApi::UsersApi* | [**delete_user**](docs/UsersApi.md#delete_user) | **DELETE** /api/v1/user | Delete User
*KindeApi::UsersApi* | [**get_user_data**](docs/UsersApi.md#get_user_data) | **GET** /api/v1/user | Get User
*KindeApi::UsersApi* | [**get_users**](docs/UsersApi.md#get_users) | **GET** /api/v1/users | List Users
*KindeApi::UsersApi* | [**refresh_user_claims**](docs/UsersApi.md#refresh_user_claims) | **POST** /api/v1/users/{user_id}/refresh_claims | Refresh User Claims and Invalidate Cache
*KindeApi::UsersApi* | [**update_user**](docs/UsersApi.md#update_user) | **PATCH** /api/v1/user | Update User


## Documentation for Models

 - [KindeApi::AddAPIsRequest](docs/AddAPIsRequest.md)
 - [KindeApi::AddOrganizationUsersRequest](docs/AddOrganizationUsersRequest.md)
 - [KindeApi::AddOrganizationUsersRequestUsersInner](docs/AddOrganizationUsersRequestUsersInner.md)
 - [KindeApi::AddOrganizationUsersResponse](docs/AddOrganizationUsersResponse.md)
 - [KindeApi::Api](docs/Api.md)
 - [KindeApi::ApiApplicationsInner](docs/ApiApplicationsInner.md)
 - [KindeApi::ApiResult](docs/ApiResult.md)
 - [KindeApi::Apis](docs/Apis.md)
 - [KindeApi::Applications](docs/Applications.md)
 - [KindeApi::ConnectedAppsAccessToken](docs/ConnectedAppsAccessToken.md)
 - [KindeApi::ConnectedAppsAuthUrl](docs/ConnectedAppsAuthUrl.md)
 - [KindeApi::CreateApplicationRequest](docs/CreateApplicationRequest.md)
 - [KindeApi::CreateApplicationResponse](docs/CreateApplicationResponse.md)
 - [KindeApi::CreateApplicationResponseApplication](docs/CreateApplicationResponseApplication.md)
 - [KindeApi::CreateFeatureFlagRequest](docs/CreateFeatureFlagRequest.md)
 - [KindeApi::CreateOrganizationRequest](docs/CreateOrganizationRequest.md)
 - [KindeApi::CreateOrganizationResponse](docs/CreateOrganizationResponse.md)
 - [KindeApi::CreateOrganizationResponseOrganization](docs/CreateOrganizationResponseOrganization.md)
 - [KindeApi::CreateOrganizationUserPermissionRequest](docs/CreateOrganizationUserPermissionRequest.md)
 - [KindeApi::CreateOrganizationUserRoleRequest](docs/CreateOrganizationUserRoleRequest.md)
 - [KindeApi::CreatePermissionRequest](docs/CreatePermissionRequest.md)
 - [KindeApi::CreateRoleRequest](docs/CreateRoleRequest.md)
 - [KindeApi::CreateSubscriberSuccessResponse](docs/CreateSubscriberSuccessResponse.md)
 - [KindeApi::CreateSubscriberSuccessResponseSubscriber](docs/CreateSubscriberSuccessResponseSubscriber.md)
 - [KindeApi::CreateUserRequest](docs/CreateUserRequest.md)
 - [KindeApi::CreateUserRequestIdentitiesInner](docs/CreateUserRequestIdentitiesInner.md)
 - [KindeApi::CreateUserRequestIdentitiesInnerDetails](docs/CreateUserRequestIdentitiesInnerDetails.md)
 - [KindeApi::CreateUserRequestProfile](docs/CreateUserRequestProfile.md)
 - [KindeApi::CreateUserResponse](docs/CreateUserResponse.md)
 - [KindeApi::Error](docs/Error.md)
 - [KindeApi::ErrorResponse](docs/ErrorResponse.md)
 - [KindeApi::GetApplicationResponse](docs/GetApplicationResponse.md)
 - [KindeApi::GetApplicationResponseApplication](docs/GetApplicationResponseApplication.md)
 - [KindeApi::GetApplicationsResponse](docs/GetApplicationsResponse.md)
 - [KindeApi::GetEnvironmentFeatureFlagsResponse](docs/GetEnvironmentFeatureFlagsResponse.md)
 - [KindeApi::GetOrganizationFeatureFlagsResponse](docs/GetOrganizationFeatureFlagsResponse.md)
 - [KindeApi::GetOrganizationFeatureFlagsResponseFeatureFlagsValue](docs/GetOrganizationFeatureFlagsResponseFeatureFlagsValue.md)
 - [KindeApi::GetOrganizationUsersResponse](docs/GetOrganizationUsersResponse.md)
 - [KindeApi::GetOrganizationsResponse](docs/GetOrganizationsResponse.md)
 - [KindeApi::GetOrganizationsUserPermissionsResponse](docs/GetOrganizationsUserPermissionsResponse.md)
 - [KindeApi::GetOrganizationsUserRolesResponse](docs/GetOrganizationsUserRolesResponse.md)
 - [KindeApi::GetPermissionsResponse](docs/GetPermissionsResponse.md)
 - [KindeApi::GetRedirectCallbackUrlsResponse](docs/GetRedirectCallbackUrlsResponse.md)
 - [KindeApi::GetRolesResponse](docs/GetRolesResponse.md)
 - [KindeApi::GetSubscriberResponse](docs/GetSubscriberResponse.md)
 - [KindeApi::GetSubscribersResponse](docs/GetSubscribersResponse.md)
 - [KindeApi::LogoutRedirectUrls](docs/LogoutRedirectUrls.md)
 - [KindeApi::Organization](docs/Organization.md)
 - [KindeApi::OrganizationUser](docs/OrganizationUser.md)
 - [KindeApi::OrganizationUserPermission](docs/OrganizationUserPermission.md)
 - [KindeApi::OrganizationUserPermissionRolesInner](docs/OrganizationUserPermissionRolesInner.md)
 - [KindeApi::OrganizationUserRole](docs/OrganizationUserRole.md)
 - [KindeApi::OrganizationUserRolePermissions](docs/OrganizationUserRolePermissions.md)
 - [KindeApi::OrganizationUserRolePermissionsPermissions](docs/OrganizationUserRolePermissionsPermissions.md)
 - [KindeApi::Permissions](docs/Permissions.md)
 - [KindeApi::RedirectCallbackUrls](docs/RedirectCallbackUrls.md)
 - [KindeApi::ReplaceLogoutRedirectURLsRequest](docs/ReplaceLogoutRedirectURLsRequest.md)
 - [KindeApi::ReplaceRedirectCallbackURLsRequest](docs/ReplaceRedirectCallbackURLsRequest.md)
 - [KindeApi::Role](docs/Role.md)
 - [KindeApi::Roles](docs/Roles.md)
 - [KindeApi::RolesPermissionResponseInner](docs/RolesPermissionResponseInner.md)
 - [KindeApi::Subscriber](docs/Subscriber.md)
 - [KindeApi::SubscribersSubscriber](docs/SubscribersSubscriber.md)
 - [KindeApi::SuccessResponse](docs/SuccessResponse.md)
 - [KindeApi::TokenErrorResponse](docs/TokenErrorResponse.md)
 - [KindeApi::TokenIntrospect](docs/TokenIntrospect.md)
 - [KindeApi::UpdateAPIApplicationsRequest](docs/UpdateAPIApplicationsRequest.md)
 - [KindeApi::UpdateAPIApplicationsRequestApplicationsInner](docs/UpdateAPIApplicationsRequestApplicationsInner.md)
 - [KindeApi::UpdateApplicationRequest](docs/UpdateApplicationRequest.md)
 - [KindeApi::UpdateEnvironementFeatureFlagOverrideRequest](docs/UpdateEnvironementFeatureFlagOverrideRequest.md)
 - [KindeApi::UpdateOrganizationRequest](docs/UpdateOrganizationRequest.md)
 - [KindeApi::UpdateOrganizationUsersRequest](docs/UpdateOrganizationUsersRequest.md)
 - [KindeApi::UpdateOrganizationUsersRequestUsersInner](docs/UpdateOrganizationUsersRequestUsersInner.md)
 - [KindeApi::UpdateOrganizationUsersResponse](docs/UpdateOrganizationUsersResponse.md)
 - [KindeApi::UpdateRolePermissionsRequest](docs/UpdateRolePermissionsRequest.md)
 - [KindeApi::UpdateRolePermissionsRequestPermissionsInner](docs/UpdateRolePermissionsRequestPermissionsInner.md)
 - [KindeApi::UpdateRolePermissionsResponse](docs/UpdateRolePermissionsResponse.md)
 - [KindeApi::UpdateRolesRequest](docs/UpdateRolesRequest.md)
 - [KindeApi::UpdateUserRequest](docs/UpdateUserRequest.md)
 - [KindeApi::UpdateUserResponse](docs/UpdateUserResponse.md)
 - [KindeApi::User](docs/User.md)
 - [KindeApi::UserIdentitiesInner](docs/UserIdentitiesInner.md)
 - [KindeApi::UserIdentity](docs/UserIdentity.md)
 - [KindeApi::UserIdentityResult](docs/UserIdentityResult.md)
 - [KindeApi::UserProfile](docs/UserProfile.md)
 - [KindeApi::UserProfileV2](docs/UserProfileV2.md)
 - [KindeApi::UsersResponse](docs/UsersResponse.md)
 - [KindeApi::UsersResponseUsersInner](docs/UsersResponseUsersInner.md)


## Documentation for Authorization


### kindeBearerAuth

- **Type**: Bearer authentication (JWT)

