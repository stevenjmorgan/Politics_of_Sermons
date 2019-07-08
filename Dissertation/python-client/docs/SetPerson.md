# SetPerson

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**api_key** | **str** | your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
**faces_uuids** | **list[str]** | list of face uuids to set person id. each face can have only one person id assigned to it. setting a person id overwrites the old value. | 
**person_id** | **str** | person id in format name@namespace. name and namespace can include letters, numbers, dots, underscores and spaces. special name random@namespace could be used to assign random person name with specific namespace. Namespace part should not exceed 60 characters. Name part should not exceed 200 characters. Setting person_id to empty string resets the person id. Faces will be permanently stored for as long as person id is assigned to them. Faces without person ids will be deleted starting from 24 hours. Resetting person id on faces generated more than 24 hours ago may immediately delete the. When face is assigned to/removed from namespace search indexes of namespaces involved will asynchrously update. It may take from seconds to serveral minutes depending on namespace size for changes to propagate. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


