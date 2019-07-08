# swagger_client.RecognizeApi

All URIs are relative to *https://www.betafaceapi.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v2_recognize_get**](RecognizeApi.md#v2_recognize_get) | **GET** /v2/recognize | gets a faces recognition result.
[**v2_recognize_post**](RecognizeApi.md#v2_recognize_post) | **POST** /v2/recognize | initiate recognition for one or more faces


# **v2_recognize_get**
> v2_recognize_get(api_key, recognize_uuid)

gets a faces recognition result.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.RecognizeApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
recognize_uuid = 'recognize_uuid_example' # str | the requested recognize identifier.

try:
    # gets a faces recognition result.
    api_instance.v2_recognize_get(api_key, recognize_uuid)
except ApiException as e:
    print("Exception when calling RecognizeApi->v2_recognize_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **recognize_uuid** | [**str**](.md)| the requested recognize identifier. | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_recognize_post**
> Recognize v2_recognize_post(body=body)

initiate recognition for one or more faces

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.RecognizeApi()
body = swagger_client.RecognizeRequest() # RecognizeRequest | request json body with parameters. (optional)

try:
    # initiate recognition for one or more faces
    api_response = api_instance.v2_recognize_post(body=body)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling RecognizeApi->v2_recognize_post: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**RecognizeRequest**](RecognizeRequest.md)| request json body with parameters. | [optional] 

### Return type

[**Recognize**](Recognize.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

