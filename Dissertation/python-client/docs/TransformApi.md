# swagger_client.TransformApi

All URIs are relative to *https://www.betafaceapi.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v2_transform_get**](TransformApi.md#v2_transform_get) | **GET** /v2/transform | gets a faces transform result.
[**v2_transform_post**](TransformApi.md#v2_transform_post) | **POST** /v2/transform | initiate transform for one or more faces


# **v2_transform_get**
> v2_transform_get(api_key, transform_uuid)

gets a faces transform result.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.TransformApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
transform_uuid = 'transform_uuid_example' # str | the requested transform identifier.

try:
    # gets a faces transform result.
    api_instance.v2_transform_get(api_key, transform_uuid)
except ApiException as e:
    print("Exception when calling TransformApi->v2_transform_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **transform_uuid** | [**str**](.md)| the requested transform identifier. | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_transform_post**
> Transform v2_transform_post(body=body)

initiate transform for one or more faces

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.TransformApi()
body = swagger_client.TransformRequest() # TransformRequest | request json body with parameters. (optional)

try:
    # initiate transform for one or more faces
    api_response = api_instance.v2_transform_post(body=body)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling TransformApi->v2_transform_post: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**TransformRequest**](TransformRequest.md)| request json body with parameters. | [optional] 

### Return type

[**Transform**](Transform.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

