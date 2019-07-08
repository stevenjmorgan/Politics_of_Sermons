# swagger_client.MediaApi

All URIs are relative to *https://www.betafaceapi.com/api*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v2_media_file_post**](MediaApi.md#v2_media_file_post) | **POST** /v2/media/file | upload media file using multipart/form-data
[**v2_media_get**](MediaApi.md#v2_media_get) | **GET** /v2/media | gets a media information.
[**v2_media_hash_get**](MediaApi.md#v2_media_hash_get) | **GET** /v2/media/hash | gets a media information using SHA256 hash of media file.
[**v2_media_post**](MediaApi.md#v2_media_post) | **POST** /v2/media | upload media file using file uri or file content as base64 encoded string


# **v2_media_file_post**
> MediaUploadResponse v2_media_file_post(api_key, file, detection_flags=detection_flags, detection_min_score=detection_min_score, detection_new_faces=detection_new_faces, set_person_id=set_person_id, recognize_targets=recognize_targets, recognize_parameters=recognize_parameters, original_filename=original_filename)

upload media file using multipart/form-data

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.MediaApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
file = '/path/to/file.txt' # file | a media file to upload
detection_flags = 'detection_flags_example' # str | (optional) comma separated list of detection flags: bestface - return only face with highest detection score, , centerface - same as bestface but gives preference to face closest to image center, basicpoints - 22 basic points detection, propoints - 101 pro points detection, classifiers - face classification and attributes, extended - extended color and geometric measurements, content - image content detection.  for example: \"basicpoints,propoints,classifiers,content\" (optional)
detection_min_score = 1.2 # float | (optional) filter faces with detection score lower than min_score. (optional)
detection_new_faces = 'detection_new_faces_example' # str | (optional) override automatic faces detection and manually specify faces locations, face points and person ids to assign.  provide a list of new faces as a string of comma separated entries with following template: { \"x\": 0, \"y\": 0, \"width\": 0, \"height\": 0, \"angle\": 0, \"points\": [ { \"x\": 0, \"y\": 0, \"type\": 0 }, { \"x\": 0, \"y\": 0, \"type\": 0 }], \"tags\": [ { \"name\": \"\",  \"value\": \"\",  \"confidence\": 1.0 }, {\"name\": \"\", \"value\": \"\", \"confidence\": 1.0 } ], \"set_person_id\": \"\"} (optional)
set_person_id = 'set_person_id_example' # str | (optional) set person id in format name@namespace to each detected face. recommended to use with detection_flags bestface, centerface and/or min_score minimum detection score parameter. you can use special name random@namespace to assign random unique name to each face in specific namespace.  for example: \"John Doe@mynamespace\" (optional)
recognize_targets = 'recognize_targets_example' # str | (optional) for each detected face run recognize against specified targets (face ids, person ids or namespaces).  provide a list of targets as comma separated string, for example \"all@mynamespace,John Doe@othernamespace\" (optional)
recognize_parameters = 'recognize_parameters_example' # str | (optional) comma separated list of recognition parameters, currently supported min_match_score (minimum recognition score), min_score (minimum detection score), gender and race filter.  for example: \"min_match_score:0.4,min_score:0.2,gender:male,race:white\" (optional)
original_filename = 'original_filename_example' # str | (optional) original media filename, path, uri or your application specific id that you want to be stored in media metadata for reference. (optional)

try:
    # upload media file using multipart/form-data
    api_response = api_instance.v2_media_file_post(api_key, file, detection_flags=detection_flags, detection_min_score=detection_min_score, detection_new_faces=detection_new_faces, set_person_id=set_person_id, recognize_targets=recognize_targets, recognize_parameters=recognize_parameters, original_filename=original_filename)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling MediaApi->v2_media_file_post: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **file** | **file**| a media file to upload | 
 **detection_flags** | **str**| (optional) comma separated list of detection flags: bestface - return only face with highest detection score, , centerface - same as bestface but gives preference to face closest to image center, basicpoints - 22 basic points detection, propoints - 101 pro points detection, classifiers - face classification and attributes, extended - extended color and geometric measurements, content - image content detection.  for example: \&quot;basicpoints,propoints,classifiers,content\&quot; | [optional] 
 **detection_min_score** | **float**| (optional) filter faces with detection score lower than min_score. | [optional] 
 **detection_new_faces** | **str**| (optional) override automatic faces detection and manually specify faces locations, face points and person ids to assign.  provide a list of new faces as a string of comma separated entries with following template: { \&quot;x\&quot;: 0, \&quot;y\&quot;: 0, \&quot;width\&quot;: 0, \&quot;height\&quot;: 0, \&quot;angle\&quot;: 0, \&quot;points\&quot;: [ { \&quot;x\&quot;: 0, \&quot;y\&quot;: 0, \&quot;type\&quot;: 0 }, { \&quot;x\&quot;: 0, \&quot;y\&quot;: 0, \&quot;type\&quot;: 0 }], \&quot;tags\&quot;: [ { \&quot;name\&quot;: \&quot;\&quot;,  \&quot;value\&quot;: \&quot;\&quot;,  \&quot;confidence\&quot;: 1.0 }, {\&quot;name\&quot;: \&quot;\&quot;, \&quot;value\&quot;: \&quot;\&quot;, \&quot;confidence\&quot;: 1.0 } ], \&quot;set_person_id\&quot;: \&quot;\&quot;} | [optional] 
 **set_person_id** | **str**| (optional) set person id in format name@namespace to each detected face. recommended to use with detection_flags bestface, centerface and/or min_score minimum detection score parameter. you can use special name random@namespace to assign random unique name to each face in specific namespace.  for example: \&quot;John Doe@mynamespace\&quot; | [optional] 
 **recognize_targets** | **str**| (optional) for each detected face run recognize against specified targets (face ids, person ids or namespaces).  provide a list of targets as comma separated string, for example \&quot;all@mynamespace,John Doe@othernamespace\&quot; | [optional] 
 **recognize_parameters** | **str**| (optional) comma separated list of recognition parameters, currently supported min_match_score (minimum recognition score), min_score (minimum detection score), gender and race filter.  for example: \&quot;min_match_score:0.4,min_score:0.2,gender:male,race:white\&quot; | [optional] 
 **original_filename** | **str**| (optional) original media filename, path, uri or your application specific id that you want to be stored in media metadata for reference. | [optional] 

### Return type

[**MediaUploadResponse**](MediaUploadResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_media_get**
> Media v2_media_get(api_key, media_uuid)

gets a media information.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.MediaApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
media_uuid = 'media_uuid_example' # str | the requested media identifier.

try:
    # gets a media information.
    api_response = api_instance.v2_media_get(api_key, media_uuid)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling MediaApi->v2_media_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **media_uuid** | [**str**](.md)| the requested media identifier. | 

### Return type

[**Media**](Media.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_media_hash_get**
> Media v2_media_hash_get(api_key, checksum)

gets a media information using SHA256 hash of media file.

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.MediaApi()
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
checksum = 'checksum_example' # str | SHA256 media file hash.

try:
    # gets a media information using SHA256 hash of media file.
    api_response = api_instance.v2_media_hash_get(api_key, checksum)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling MediaApi->v2_media_hash_get: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **api_key** | [**str**](.md)| your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
 **checksum** | **str**| SHA256 media file hash. | 

### Return type

[**Media**](Media.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v2_media_post**
> MediaUploadResponse v2_media_post(body=body)

upload media file using file uri or file content as base64 encoded string

### Example
```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.MediaApi()
body = swagger_client.MediaUpload() # MediaUpload | request json body with parameters. (optional)

try:
    # upload media file using file uri or file content as base64 encoded string
    api_response = api_instance.v2_media_post(body=body)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling MediaApi->v2_media_post: %s\n" % e)
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**MediaUpload**](MediaUpload.md)| request json body with parameters. | [optional] 

### Return type

[**MediaUploadResponse**](MediaUploadResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

