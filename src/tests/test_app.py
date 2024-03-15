from flask_testing import TestCase

import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app import app

class FlaskTestCase(TestCase):
    def create_app(self):
        app.config['TESTING'] = True
        return app

    def test_hello_route(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode('utf-8'), "Hello World!")

if __name__ == '__main__':
    import unittest
    unittest.main()