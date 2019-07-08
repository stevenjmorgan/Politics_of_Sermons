# Face

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**face_uuid** | **str** | face unique identifier. | [optional] 
**media_uuid** | **str** | media unique identifier. | [optional] 
**x** | **float** | x coordinate of the face bounding box center in pixels. | [optional] 
**y** | **float** | y coordinate of the face bounding box center in pixels. | [optional] 
**width** | **float** | width of the face bounding box center in pixels. | [optional] 
**height** | **float** | height of the face bounding box center in pixels. | [optional] 
**angle** | **float** | in-plane rotation (roll) of the face bounding box center in degrees. | [optional] 
**detection_score** | **float** | confidence-like value of the face detection, low detection scores (lower than 0.5 for example) correspond to higher probability of false detection. | [optional] 
**points** | [**list[Point]**](Point.md) | facial landmark points. | [optional] 
**user_points** | [**list[Point]**](Point.md) | user-defined facial landmark points. | [optional] 
**tags** | [**list[Tag]**](Tag.md) | list of detected or labelled face tags - classifiers, attributes, measurements. | [optional] 
**person_id** | **str** | assigned person id and namespace in format name@namespace. | [optional] 
**appearance_id** | **int** | reserved for future video processing | [optional] 
**start** | **str** | reserved for future video processing | [optional] 
**duration** | **str** | reserved for future video processing | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


