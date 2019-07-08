# swagger_client.FaceApi

All URIs are relative to *https://www.betafaceapi.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v2_face_cropped_get**](FaceApi.md#v2_face_cropped_get) | **GET** /v2/face/cropped | gets a single cropped face information including cropped face image.
[**v2_face_get**](FaceApi.md#v2_face_get) | **GET** /v2/face | gets a single face information.


# **v2_face_cropped_get**
> CroppedFace v2_face_cropped_get(api_key, face_uuid)

gets a single cropped face information including cropped face image.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.FaceApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
face_uuid = 'face_uuid_example' # str | the requested media identifier.

try:
    # gets a single cropped face information including cropped face image.
    api_response = api_instance.v2_face_cropped_get(api_key, face_uuid)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling FaceApi->v2_face_cropped_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **face_uuid** | [**str**](.md)| the requested media identifier. | 

### Return type

[**CroppedFace**](CroppedFace.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_face_get**
> Face v2_face_get(api_key, face_uuid)

gets a single face information.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.FaceApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
face_uuid = 'face_uuid_example' # str | the requested media identifier.

try:
    # gets a single face information.
    api_response = api_instance.v2_face_get(api_key, face_uuid)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling FaceApi->v2_face_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **face_uuid** | [**str**](.md)| the requested media identifier. | 

### Return type

[**Face**](Face.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

