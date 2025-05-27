# KindeApi::PropertyCategoriesApi

All URIs are relative to *https://your_kinde_subdomain.kinde.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_category**](PropertyCategoriesApi.md#create_category) | **POST** /api/v1/property_categories | Create Category |
| [**get_categories**](PropertyCategoriesApi.md#get_categories) | **GET** /api/v1/property_categories | List categories |
| [**update_category**](PropertyCategoriesApi.md#update_category) | **PUT** /api/v1/property_categories/{category_id} | Update Category |


## create_category

> <CreateCategoryResponse> create_category(create_category_request)

Create Category

Create category.  <div>   <code>create:property_categories</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertyCategoriesApi.new
create_category_request = KindeApi::CreateCategoryRequest.new({name: 'name_example', context: 'org'}) # CreateCategoryRequest | Category details.

begin
  # Create Category
  result = api_instance.create_category(create_category_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertyCategoriesApi->create_category: #{e}"
end
```

#### Using the create_category_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<CreateCategoryResponse>, Integer, Hash)> create_category_with_http_info(create_category_request)

```ruby
begin
  # Create Category
  data, status_code, headers = api_instance.create_category_with_http_info(create_category_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <CreateCategoryResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertyCategoriesApi->create_category_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **create_category_request** | [**CreateCategoryRequest**](CreateCategoryRequest.md) | Category details. |  |

### Return type

[**CreateCategoryResponse**](CreateCategoryResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8


## get_categories

> <GetCategoriesResponse> get_categories(opts)

List categories

Returns a list of categories.  <div>   <code>read:property_categories</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertyCategoriesApi.new
opts = {
  page_size: 56, # Integer | Number of results per page. Defaults to 10 if parameter not sent.
  starting_after: 'starting_after_example', # String | The ID of the category to start after.
  ending_before: 'ending_before_example', # String | The ID of the category to end before.
  context: 'usr' # String | Filter the results by User or Organization context
}

begin
  # List categories
  result = api_instance.get_categories(opts)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertyCategoriesApi->get_categories: #{e}"
end
```

#### Using the get_categories_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<GetCategoriesResponse>, Integer, Hash)> get_categories_with_http_info(opts)

```ruby
begin
  # List categories
  data, status_code, headers = api_instance.get_categories_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <GetCategoriesResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertyCategoriesApi->get_categories_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **page_size** | **Integer** | Number of results per page. Defaults to 10 if parameter not sent. | [optional] |
| **starting_after** | **String** | The ID of the category to start after. | [optional] |
| **ending_before** | **String** | The ID of the category to end before. | [optional] |
| **context** | **String** | Filter the results by User or Organization context | [optional] |

### Return type

[**GetCategoriesResponse**](GetCategoriesResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json; charset=utf-8, application/json


## update_category

> <SuccessResponse> update_category(category_id, update_category_request)

Update Category

Update category.  <div>   <code>update:property_categories</code> </div> 

### Examples

```ruby
require 'time'
require 'kinde_api'
# setup authorization
KindeApi.configure do |config|
  # Configure Bearer authorization (JWT): kindeBearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = KindeApi::PropertyCategoriesApi.new
category_id = 'category_id_example' # String | The unique identifier for the category.
update_category_request = KindeApi::UpdateCategoryRequest.new # UpdateCategoryRequest | The fields of the category to update.

begin
  # Update Category
  result = api_instance.update_category(category_id, update_category_request)
  p result
rescue KindeApi::ApiError => e
  puts "Error when calling PropertyCategoriesApi->update_category: #{e}"
end
```

#### Using the update_category_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SuccessResponse>, Integer, Hash)> update_category_with_http_info(category_id, update_category_request)

```ruby
begin
  # Update Category
  data, status_code, headers = api_instance.update_category_with_http_info(category_id, update_category_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SuccessResponse>
rescue KindeApi::ApiError => e
  puts "Error when calling PropertyCategoriesApi->update_category_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **category_id** | **String** | The unique identifier for the category. |  |
| **update_category_request** | [**UpdateCategoryRequest**](UpdateCategoryRequest.md) | The fields of the category to update. |  |

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

[kindeBearerAuth](../README.md#kindeBearerAuth)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json, application/json; charset=utf-8

