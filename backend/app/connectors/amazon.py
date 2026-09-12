from typing import Any


AMAZON_SA_URL = "https://www.amazon.sa/"


def search_amazon(query: str) -> list[dict[str, Any]]:
    """
    Amazon.sa connector.

    هذه النسخة تجريبية فقط.
    سيتم ربطها بمصدر بيانات Amazon الحقيقي لاحقًا.
    """

    query = query.strip()

    if not query:
        return []

    return [
        {
            "store": "Amazon.sa",
            "title": query,
            "price": None,
            "currency": "SAR",
            "url": AMAZON_SA_URL,
            "image": None,
            "in_stock": None,
        }
    ]
