# MediaUploadFile

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**api_key** | **str** | your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
**detection_flags** | **str** | (optional) comma separated list of detection flags: bestface - return only face with highest detection score, , centerface - same as bestface but gives preference to face closest to image center, basicpoints - 22 basic points detection, propoints - 101 pro points detection, classifiers - face classification and attributes, extended - extended color and geometric measurements, content - image content detection.  for example: \&quot;basicpoints,propoints,classifiers,content\&quot; | [optional] 
**detection_min_score** | **float** | (optional) filter faces with detection score lower than min_score. | [optional] 
**detection_new_faces** | **str** | (optional) override automatic faces detection and manually specify faces locations, face points and person ids to assign.  provide a list of new faces as a string of comma separated entries with following template: { \&quot;x\&quot;: 0, \&quot;y\&quot;: 0, \&quot;width\&quot;: 0, \&quot;height\&quot;: 0, \&quot;angle\&quot;: 0, \&quot;points\&quot;: [ { \&quot;x\&quot;: 0, \&quot;y\&quot;: 0, \&quot;type\&quot;: 0 }, { \&quot;x\&quot;: 0, \&quot;y\&quot;: 0, \&quot;type\&quot;: 0 }], \&quot;tags\&quot;: [ { \&quot;name\&quot;: \&quot;\&quot;,  \&quot;value\&quot;: \&quot;\&quot;,  \&quot;confidence\&quot;: 1.0 }, {\&quot;name\&quot;: \&quot;\&quot;, \&quot;value\&quot;: \&quot;\&quot;, \&quot;confidence\&quot;: 1.0 } ], \&quot;set_person_id\&quot;: \&quot;\&quot;} | [optional] 
**set_person_id** | **str** | (optional) set person id in format name@namespace to each detected face. recommended to use with detection_flags bestface, centerface and/or min_score minimum detection score parameter. you can use special name random@namespace to assign random unique name to each face in specific namespace.  for example: \&quot;John Doe@mynamespace\&quot; | [optional] 
**recognize_targets** | **str** | (optional) for each detected face run recognize against specified targets (face ids, person ids or namespaces).  provide a list of targets as comma separated string, for example \&quot;all@mynamespace,John Doe@othernamespace\&quot; | [optional] 
**recognize_parameters** | **str** | (optional) comma separated list of recognition parameters, currently supported min_match_score (minimum recognition score), min_score (minimum detection score), gender and race filter.  for example: \&quot;min_match_score:0.4,min_score:0.2,gender:male,race:white\&quot; | [optional] 
**original_filename** | **str** | (optional) original media filename, path, uri or your application specific id that you want to be stored in media metadata for reference. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


