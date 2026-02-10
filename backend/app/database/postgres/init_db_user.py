"""
Initialisation de la base PostgreSQL
"""

from pathlib import Path

import psycopg2

# from app.database.connexion_postgres import PG_CONFIG
from app.database.connexion_postgres import POSTGRES_URL


def init_postgres_db():
    """Initialise la base PostgreSQL"""
    print("🐘 Initialisation de PostgreSQL...")

    # Connexion
    conn = psycopg2.connect(POSTGRES_URL)
    cur = conn.cursor()

    # Lire le schema
    schema_path = Path(__file__).parent / "schema.sql"
    with open(schema_path) as f:
        schema_sql = f.read()

    # Exécuter
    cur.execute(schema_sql)
    conn.commit()

    print("✅ Base PostgreSQL initialisée")

    cur.close()
    conn.close()


if __name__ == "__main__":
    init_postgres_db()
