# swagger_client.PersonApi

All URIs are relative to *https://www.betafaceapi.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v2_person_get**](PersonApi.md#v2_person_get) | **GET** /v2/person | lists all persons and their faces identifiers sorted by namespace and person name alphabetically. (Administrative endpoint - API secret required)
[**v2_person_post**](PersonApi.md#v2_person_post) | **POST** /v2/person | sets or overwrites person id for each specified face.


# **v2_person_get**
> list[Person] v2_person_get(api_key, api_secret, person_id=person_id)

lists all persons and their faces identifiers sorted by namespace and person name alphabetically. (Administrative endpoint - API secret required)

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.PersonApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
api_secret = 'api_secret_example' # str | your API secret. It is not recommended to expose your application secret at client side.
person_id = ['person_id_example'] # list[str] | (optional) query parameters array of specific person ids or all@namespace to list persons in that namespace (optional)

try:
    # lists all persons and their faces identifiers sorted by namespace and person name alphabetically. (Administrative endpoint - API secret required)
    api_response = api_instance.v2_person_get(api_key, api_secret, person_id=person_id)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling PersonApi->v2_person_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **api_secret** | [**str**](.md)| your API secret. It is not recommended to expose your application secret at client side. | 
 **person_id** | [**list[str]**](str.md)| (optional) query parameters array of specific person ids or all@namespace to list persons in that namespace | [optional] 

### Return type

[**list[Person]**](Person.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_person_post**
> v2_person_post(body=body)

sets or overwrites person id for each specified face.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.PersonApi()
body = swagger_client.SetPerson() # SetPerson | request json body with parameters. (optional)

try:
    # sets or overwrites person id for each specified face.
    api_instance.v2_person_post(body=body)
except ApiException as e:
    print("Exception when calling PersonApi->v2_person_post: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**SetPerson**](SetPerson.md)| request json body with parameters. | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

