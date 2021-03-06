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
from swagger_client.api.media_api import MediaApi  # noqa: E501
from swagger_client.rest import ApiException


class TestMediaApi(unittest.TestCase):
    """MediaApi unit test stubs"""

    def setUp(self):
        self.api = swagger_client.api.media_api.MediaApi()  # noqa: E501

    def tearDown(self):
        pass

    def test_v2_media_file_post(self):
        """Test case for v2_media_file_post

        upload media file using multipart/form-data  # noqa: E501
        """
        pass

    def test_v2_media_get(self):
        """Test case for v2_media_get

        gets a media information.  # noqa: E501
        """
        pass

    def test_v2_media_hash_get(self):
        """Test case for v2_media_hash_get

        gets a media information using SHA256 hash of media file.  # noqa: E501
        """
        pass

    def test_v2_media_post(self):
        """Test case for v2_media_post

        upload media file using file uri or file content as base64 encoded string  # noqa: E501
        """
        pass


if __name__ == '__main__':
    unittest.main()
