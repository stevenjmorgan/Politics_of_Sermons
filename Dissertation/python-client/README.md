# swagger-client
Betaface face recognition API.

This Python package is automatically generated by the [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) project:

- API version: 2.0
- Package version: 1.0.0
- Build package: io.swagger.codegen.languages.PythonClientCodegen

## Requirements.

Python 2.7 and 3.4+

## Installation & Usage
### pip install

If the python package is hosted on Github, you can install directly from Github

```sh
pip install git+https://github.com//.git
```
(you may need to run `pip` with root permission: `sudo pip install git+https://github.com//.git`)

Then import the package:
```python
import swagger_client 
```

### Setuptools

Install via [Setuptools](http://pypi.python.org/pypi/setuptools).

```sh
python setup.py install --user
```
(or `sudo python setup.py install` to install the package for all users)

Then import the package:
```python
import swagger_client
```

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

```python
from __future__ import print_function
import time
import swagger_client
from swagger_client.rest import ApiException
from pprint import pprint

# create an instance of the API class
api_instance = swagger_client.AdminApi(swagger_client.ApiClient(configuration))
api_key = 'api_key_example' # str | your API key or d45fd466-51e2-4701-8da8-04351c872236
api_secret = 'api_secret_example' # str | your API secret. It is not recommended to expose your application secret at client side.

try:
    # get API usage information. (Administrative endpoint - API secret required)
    api_response = api_instance.v2_admin_usage_get(api_key, api_secret)
    pprint(api_response)
except ApiException as e:
    print("Exception when calling AdminApi->v2_admin_usage_get: %s\n" % e)

```

## Documentation for API Endpoints

All URIs are relative to *https://www.betafaceapi.com/api*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*AdminApi* | [**v2_admin_usage_get**](docs/AdminApi.md#v2_admin_usage_get) | **GET** /v2/admin/usage | get API usage information. (Administrative endpoint - API secret required)
*FaceApi* | [**v2_face_cropped_get**](docs/FaceApi.md#v2_face_cropped_get) | **GET** /v2/face/cropped | gets a single cropped face information including cropped face image.
*FaceApi* | [**v2_face_get**](docs/FaceApi.md#v2_face_get) | **GET** /v2/face | gets a single face information.
*MediaApi* | [**v2_media_file_post**](docs/MediaApi.md#v2_media_file_post) | **POST** /v2/media/file | upload media file using multipart/form-data
*MediaApi* | [**v2_media_get**](docs/MediaApi.md#v2_media_get) | **GET** /v2/media | gets a media information.
*MediaApi* | [**v2_media_hash_get**](docs/MediaApi.md#v2_media_hash_get) | **GET** /v2/media/hash | gets a media information using SHA256 hash of media file.
*MediaApi* | [**v2_media_post**](docs/MediaApi.md#v2_media_post) | **POST** /v2/media | upload media file using file uri or file content as base64 encoded string
*PersonApi* | [**v2_person_get**](docs/PersonApi.md#v2_person_get) | **GET** /v2/person | lists all persons and their faces identifiers sorted by namespace and person name alphabetically. (Administrative endpoint - API secret required)
*PersonApi* | [**v2_person_post**](docs/PersonApi.md#v2_person_post) | **POST** /v2/person | sets or overwrites person id for each specified face.
*RecognizeApi* | [**v2_recognize_get**](docs/RecognizeApi.md#v2_recognize_get) | **GET** /v2/recognize | gets a faces recognition result.
*RecognizeApi* | [**v2_recognize_post**](docs/RecognizeApi.md#v2_recognize_post) | **POST** /v2/recognize | initiate recognition for one or more faces
*TransformApi* | [**v2_transform_get**](docs/TransformApi.md#v2_transform_get) | **GET** /v2/transform | gets a faces transform result.
*TransformApi* | [**v2_transform_post**](docs/TransformApi.md#v2_transform_post) | **POST** /v2/transform | initiate transform for one or more faces


## Documentation For Models

 - [CroppedFace](docs/CroppedFace.md)
 - [Error](docs/Error.md)
 - [Face](docs/Face.md)
 - [Match](docs/Match.md)
 - [Media](docs/Media.md)
 - [MediaUpload](docs/MediaUpload.md)
 - [MediaUploadFile](docs/MediaUploadFile.md)
 - [MediaUploadResponse](docs/MediaUploadResponse.md)
 - [NewFace](docs/NewFace.md)
 - [Person](docs/Person.md)
 - [Point](docs/Point.md)
 - [Recognize](docs/Recognize.md)
 - [RecognizeRequest](docs/RecognizeRequest.md)
 - [RecognizeResult](docs/RecognizeResult.md)
 - [SetPerson](docs/SetPerson.md)
 - [Tag](docs/Tag.md)
 - [TagMedia](docs/TagMedia.md)
 - [Transform](docs/Transform.md)
 - [TransformRequest](docs/TransformRequest.md)
 - [Usage](docs/Usage.md)
 - [UsageDaily](docs/UsageDaily.md)


## Documentation For Authorization

 All endpoints do not require authorization.


## Author


