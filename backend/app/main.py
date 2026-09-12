from fastapi import FastAPI, Query
from typing import Optional

app = FastAPI(
    title="Qarenha API",
    description="Backend for Qarenha product comparison engine",
    version="1.0.0",
)


@app.get("/")
def home():
    return {
        "message": "Qarenha backend is running"
    }


@app.get("/api/search")
def search_products(
    q: str = Query(..., min_length=1, description="Product search query")
):
    query = q.strip()

    return {
        "query": query,
        "results": [
            {
                "store": "Amazon.sa",
                "title": f"{query} - Amazon.sa",
                "price": None,
                "currency": "SAR",
                "url": "https://www.amazon.sa/",
                "in_stock": None,
            },
            {
                "store": "Noon Saudi",
                "title": f"{query} - Noon",
                "price": None,
                "currency": "SAR",
                "url": "https://www.noon.com/saudi-ar/",
                "in_stock": None,
            },
            {
                "store": "SHEIN",
                "title": f"{query} - SHEIN",
                "price": None,
                "currency": "SAR",
                "url": "https://m.shein.com/ar/",
                "in_stock": None,
            },
        ],
    }
