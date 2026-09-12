from fastapi import FastAPI

app = FastAPI(title="Qarenha API")


@app.get("/")
def home():
    return {
        "message": "Qarenha API is running"
    }
