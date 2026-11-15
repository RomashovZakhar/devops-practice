import os

import psycopg
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="items-api")

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://app:password@db:5432/app")


class ItemIn(BaseModel):
    name: str


def get_conn():
    return psycopg.connect(DATABASE_URL, connect_timeout=3)


def ensure_table(conn):
    conn.execute(
        "CREATE TABLE IF NOT EXISTS items (id SERIAL PRIMARY KEY, name TEXT NOT NULL)"
    )


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/items")
def list_items():
    try:
        with get_conn() as conn:
            ensure_table(conn)
            rows = conn.execute("SELECT id, name FROM items ORDER BY id").fetchall()
    except psycopg.OperationalError as exc:
        raise HTTPException(status_code=503, detail="database unavailable") from exc
    return [{"id": r[0], "name": r[1]} for r in rows]


@app.post("/items", status_code=201)
def create_item(item: ItemIn):
    try:
        with get_conn() as conn:
            ensure_table(conn)
            row = conn.execute(
                "INSERT INTO items (name) VALUES (%s) RETURNING id", (item.name,)
            ).fetchone()
    except psycopg.OperationalError as exc:
        raise HTTPException(status_code=503, detail="database unavailable") from exc
    return {"id": row[0], "name": item.name}

# test
# test