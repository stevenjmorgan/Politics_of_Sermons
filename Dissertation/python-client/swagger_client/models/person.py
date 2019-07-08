# coding: utf-8

"""
    Betaface API 2.0

    Betaface face recognition API.  # noqa: E501

    OpenAPI spec version: 2.0
    
    Generated by: https://github.com/swagger-api/swagger-codegen.git
"""


import pprint
import re  # noqa: F401

import six


class Person(object):
    """NOTE: This class is auto generated by the swagger code generator program.

    Do not edit the class manually.
    """

    """
    Attributes:
      swagger_types (dict): The key is attribute name
                            and the value is attribute type.
      attribute_map (dict): The key is attribute name
                            and the value is json key in definition.
    """
    swagger_types = {
        'person_id': 'str',
        'faces_uuids': 'list[str]'
    }

    attribute_map = {
        'person_id': 'person_id',
        'faces_uuids': 'faces_uuids'
    }

    def __init__(self, person_id=None, faces_uuids=None):  # noqa: E501
        """Person - a model defined in Swagger"""  # noqa: E501

        self._person_id = None
        self._faces_uuids = None
        self.discriminator = None

        if person_id is not None:
            self.person_id = person_id
        if faces_uuids is not None:
            self.faces_uuids = faces_uuids

    @property
    def person_id(self):
        """Gets the person_id of this Person.  # noqa: E501

        person identifier  # noqa: E501

        :return: The person_id of this Person.  # noqa: E501
        :rtype: str
        """
        return self._person_id

    @person_id.setter
    def person_id(self, person_id):
        """Sets the person_id of this Person.

        person identifier  # noqa: E501

        :param person_id: The person_id of this Person.  # noqa: E501
        :type: str
        """

        self._person_id = person_id

    @property
    def faces_uuids(self):
        """Gets the faces_uuids of this Person.  # noqa: E501

        list of face uuids with this person assigned  # noqa: E501

        :return: The faces_uuids of this Person.  # noqa: E501
        :rtype: list[str]
        """
        return self._faces_uuids

    @faces_uuids.setter
    def faces_uuids(self, faces_uuids):
        """Sets the faces_uuids of this Person.

        list of face uuids with this person assigned  # noqa: E501

        :param faces_uuids: The faces_uuids of this Person.  # noqa: E501
        :type: list[str]
        """

        self._faces_uuids = faces_uuids

    def to_dict(self):
        """Returns the model properties as a dict"""
        result = {}

        for attr, _ in six.iteritems(self.swagger_types):
            value = getattr(self, attr)
            if isinstance(value, list):
                result[attr] = list(map(
                    lambda x: x.to_dict() if hasattr(x, "to_dict") else x,
                    value
                ))
            elif hasattr(value, "to_dict"):
                result[attr] = value.to_dict()
            elif isinstance(value, dict):
                result[attr] = dict(map(
                    lambda item: (item[0], item[1].to_dict())
                    if hasattr(item[1], "to_dict") else item,
                    value.items()
                ))
            else:
                result[attr] = value
        if issubclass(Person, dict):
            for key, value in self.items():
                result[key] = value

        return result

    def to_str(self):
        """Returns the string representation of the model"""
        return pprint.pformat(self.to_dict())

    def __repr__(self):
        """For `print` and `pprint`"""
        return self.to_str()

    def __eq__(self, other):
        """Returns true if both objects are equal"""
        if not isinstance(other, Person):
            return False

        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        """Returns true if both objects are not equal"""
        return not self == other
