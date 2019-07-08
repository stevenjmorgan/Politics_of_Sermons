# RecognizeRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**api_key** | **str** | your API key or d45fd466-51e2-4701-8da8-04351c872236 | 
**faces_uuids** | **list[str]** | list of face unique identifiers that should be recognized. | 
**targets** | **list[str]** | list of recognition targets which can include face identifiers, fully qualified person ids in format name@namespace or entire namespaces in format all@namespace. | 
**parameters** | **str** | (optional) comma separated list of recognition parameters, currently supported min_match_score (minimum recognition score), min_score (minimum detection score), gender and race filter.  for example: \&quot;min_match_score:0.4,min_score:0.2,gender:male,race:white\&quot; | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


