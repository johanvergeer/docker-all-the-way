from unittest import TestCase

import psycopg2

from app.utils import read_secret


class TestDatabaseConnection(TestCase):
    def test_database_connection(self):
        # Connect to an existing database
        connection = psycopg2.connect(
            user=read_secret("postgres_user"),
            password=read_secret("postgres_password"),
            host="db",
            port="5432",
            database="docker_all_the_way",
        )
