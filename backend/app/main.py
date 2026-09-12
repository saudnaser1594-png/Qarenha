from fastapi import FastAPI, Query

from app.connectors.amazon import search_amazon


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

    amazon_results = search_amazon(query)

    return {
        "query": query,
        "results": amazon_results,
    }
