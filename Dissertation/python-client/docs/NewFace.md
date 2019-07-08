# NewFace

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**x** | **float** | x coordinate of the face bounding box center in pixels. | [optional] 
**y** | **float** | y coordinate of the face bounding box center in pixels. | [optional] 
**width** | **float** | width of the face bounding box center in pixels. | [optional] 
**height** | **float** | height of the face bounding box center in pixels. | [optional] 
**angle** | **float** | in-plane rotation (roll) of the face bounding box center in degrees. | [optional] 
**points** | [**list[Point]**](Point.md) | face points. you have to specify minimum 3 points coordinates - type 512 (left eye), type 768 (right eye), type 2816 (mouth). point names are not required. | 
**tags** | [**list[Tag]**](Tag.md) | (optional) face tags or labels to set manually. | [optional] 
**set_person_id** | **str** | (optional) manually assign person id in format name@namespace. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


