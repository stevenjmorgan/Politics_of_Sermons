# swagger_client.AdminApi

All URIs are relative to *https://www.betafaceapi.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v2_admin_usage_get**](AdminApi.md#v2_admin_usage_get) | **GET** /v2/admin/usage | get API usage information. (Administrative endpoint - API secret required)


# **v2_admin_usage_get**
> Usage v2_admin_usage_get(api_key, api_secret)

get API usage information. (Administrative endpoint - API secret required)

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.AdminApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
api_secret = 'api_secret_example' # str | your API secret. It is not recommended to expose your application secret at client side.

try:
    # get API usage information. (Administrative endpoint - API secret required)
    api_response = api_instance.v2_admin_usage_get(api_key, api_secret)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling AdminApi->v2_admin_usage_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **api_secret** | [**str**](.md)| your API secret. It is not recommended to expose your application secret at client side. | 

### Return type

[**Usage**](Usage.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

