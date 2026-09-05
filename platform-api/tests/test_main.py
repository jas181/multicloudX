from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_health():
    assert client.get("/health").json()["status"] == "UP"

def test_overview_has_clouds():
    assert len(client.get("/command-center/overview").json()["clouds"]) == 3

def test_unknown_migration_is_not_found():
    assert client.get("/command-center/migrations/missing").status_code == 404
