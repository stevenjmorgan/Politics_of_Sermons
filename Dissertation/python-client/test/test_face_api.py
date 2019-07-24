# coding: utf-8

"""
    Betaface API 2.0

    Betaface face recognition API.  # noqa: E501

    OpenAPI spec version: 2.0
    
    Generated by: https://github.com/swagger-api/swagger-codegen.git
"""


from __future__ import absolute_import

import unittest

import swagger_client
from swagger_client.api.face_api import FaceApi  # noqa: E501
from swagger_client.rest import ApiException


class TestFaceApi(unittest.TestCase):
    """FaceApi unit test stubs"""

    def setUp(self):
        self.api = swagger_client.api.face_api.FaceApi()  # noqa: E501

    def tearDown(self):
        pass

    def test_v2_face_cropped_get(self):
        """Test case for v2_face_cropped_get

        gets a single cropped face information including cropped face image.  # noqa: E501
        """
        pass

    def test_v2_face_get(self):
        """Test case for v2_face_get

        gets a single face information.  # noqa: E501
        """
        pass


if __name__ == '__main__':
    unittest.main()