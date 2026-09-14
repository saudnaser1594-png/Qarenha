-- ============================================================
-- Qarenha - Database Schema
-- Product Search & Price Comparison Engine
-- PostgreSQL
-- ============================================================

BEGIN;

-- ============================================================
-- 1. Extensions
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;


-- ============================================================
-- 2. Stores
-- ============================================================

CREATE TABLE stores (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    domain VARCHAR(255) NOT NULL UNIQUE,
    homepage_url TEXT NOT NULL,
    country_code VARCHAR(2) NOT NULL DEFAULT 'SA',
    currency VARCHAR(3) NOT NULL DEFAULT 'SAR',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 3. Categories
-- ============================================================

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    slug VARCHAR(150) NOT NULL UNIQUE,
    parent_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. Products
-- ============================================================

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,

    category_id BIGINT
        REFERENCES categories(id)
        ON DELETE SET NULL,

    name TEXT NOT NULL,
    brand VARCHAR(150),
    model VARCHAR(150),

    model_number VARCHAR(150),
    barcode VARCHAR(100),
    sku VARCHAR(150),

    description TEXT,

    image_url TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 5. Product Variants
-- ============================================================

CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL
        REFERENCES products(id)
        ON DELETE CASCADE,

    sku VARCHAR(150),
    variant_name VARCHAR(255),

    color VARCHAR(100),
    size VARCHAR(100),
    product_size VARCHAR(100),

    storage VARCHAR(100),
    ram VARCHAR(100),

    processor VARCHAR(150),
    processor_details TEXT,

    quality VARCHAR(100),

    barcode VARCHAR(100),

    attributes JSONB NOT NULL DEFAULT '{}'::jsonb,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 6. Sellers
-- ============================================================

CREATE TABLE sellers (
    id BIGSERIAL PRIMARY KEY,

    store_id BIGINT NOT NULL
        REFERENCES stores(id)
        ON DELETE CASCADE,

    name VARCHAR(255) NOT NULL,

    external_seller_id VARCHAR(255),
    seller_url TEXT,

    rating NUMERIC(3,2),
    review_count INTEGER,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_store_seller
        UNIQUE (store_id, external_seller_id)
);


-- ============================================================
-- 7. Offers
-- ============================================================

CREATE TABLE offers (
    id BIGSERIAL PRIMARY KEY,

    variant_id BIGINT NOT NULL
        REFERENCES product_variants(id)
        ON DELETE CASCADE,

    store_id BIGINT NOT NULL
        REFERENCES stores(id)
        ON DELETE CASCADE,

    seller_id BIGINT
        REFERENCES sellers(id)
        ON DELETE SET NULL,

    external_product_id VARCHAR(255),
    external_offer_id VARCHAR(255),

    external_url TEXT NOT NULL,

    price NUMERIC(12,2),
    shipping_fee NUMERIC(12,2) NOT NULL DEFAULT 0,

    currency VARCHAR(3) NOT NULL DEFAULT 'SAR',

    in_stock BOOLEAN,
    availability_text VARCHAR(255),

    rating NUMERIC(3,2),
    review_count INTEGER,

    last_updated TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 8. Price History
-- ============================================================

CREATE TABLE price_history (
    id BIGSERIAL PRIMARY KEY,

    offer_id BIGINT NOT NULL
        REFERENCES offers(id)
        ON DELETE CASCADE,

    price NUMERIC(12,2) NOT NULL,
    shipping_fee NUMERIC(12,2) NOT NULL DEFAULT 0,

    currency VARCHAR(3) NOT NULL DEFAULT 'SAR',

    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 9. Product Search Identifiers
-- ============================================================

CREATE TABLE product_identifiers (
    id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL
        REFERENCES products(id)
        ON DELETE CASCADE,

    identifier_type VARCHAR(50) NOT NULL,
    identifier_value VARCHAR(255) NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_product_identifier
        UNIQUE (identifier_type, identifier_value)
);


-- ============================================================
-- 10. Shipping Information
-- ============================================================

CREATE TABLE offer_shipping (
    id BIGSERIAL PRIMARY KEY,

    offer_id BIGINT NOT NULL
        REFERENCES offers(id)
        ON DELETE CASCADE,

    destination_country VARCHAR(2) NOT NULL DEFAULT 'SA',

    shipping_fee NUMERIC(12,2) NOT NULL DEFAULT 0,

    estimated_min_days INTEGER,
    estimated_max_days INTEGER,

    is_free_shipping BOOLEAN NOT NULL DEFAULT FALSE,

    last_updated TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_offer_destination
        UNIQUE (offer_id, destination_country)
);


-- ============================================================
-- 11. Product Images
-- ============================================================

CREATE TABLE product_images (
    id BIGSERIAL PRIMARY KEY,

    product_id BIGINT NOT NULL
        REFERENCES products(id)
        ON DELETE CASCADE,

    variant_id BIGINT
        REFERENCES product_variants(id)
        ON DELETE CASCADE,

    image_url TEXT NOT NULL,

    image_hash VARCHAR(255),

    sort_order INTEGER NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 12. Search Logs
-- ============================================================

CREATE TABLE search_logs (
    id BIGSERIAL PRIMARY KEY,

    query TEXT NOT NULL,

    normalized_query TEXT,

    results_count INTEGER NOT NULL DEFAULT 0,

    searched_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 13. Indexes - Categories
-- ============================================================

CREATE INDEX idx_categories_parent
    ON categories(parent_id);

CREATE INDEX idx_categories_name_trgm
    ON categories USING GIN (name gin_trgm_ops);


-- ============================================================
-- 14. Indexes - Products
-- ============================================================

CREATE INDEX idx_products_category
    ON products(category_id);

CREATE INDEX idx_products_brand
    ON products(brand);

CREATE INDEX idx_products_model
    ON products(model);

CREATE INDEX idx_products_barcode
    ON products(barcode);

CREATE INDEX idx_products_model_number
    ON products(model_number);

CREATE INDEX idx_products_sku
    ON products(sku);

CREATE INDEX idx_products_name_trgm
    ON products USING GIN (name gin_trgm_ops);

CREATE INDEX idx_products_brand_trgm
    ON products USING GIN (brand gin_trgm_ops);


-- ============================================================
-- 15. Indexes - Product Variants
-- ============================================================

CREATE INDEX idx_product_variants_product
    ON product_variants(product_id);

CREATE INDEX idx_product_variants_sku
    ON product_variants(sku);

CREATE INDEX idx_product_variants_barcode
    ON product_variants(barcode);

CREATE INDEX idx_product_variants_color
    ON product_variants(color);

CREATE INDEX idx_product_variants_size
    ON product_variants(size);

CREATE INDEX idx_product_variants_storage
    ON product_variants(storage);

CREATE INDEX idx_product_variants_ram
    ON product_variants(ram);

CREATE INDEX idx_product_variants_attributes
    ON product_variants USING GIN(attributes);


-- ============================================================
-- 16. Indexes - Sellers
-- ============================================================

CREATE INDEX idx_sellers_store
    ON sellers(store_id);

CREATE INDEX idx_sellers_external_id
    ON sellers(external_seller_id);


-- ============================================================
-- 17. Indexes - Offers
-- ============================================================

CREATE INDEX idx_offers_variant
    ON offers(variant_id);

CREATE INDEX idx_offers_store
    ON offers(store_id);

CREATE INDEX idx_offers_seller
    ON offers(seller_id);

CREATE INDEX idx_offers_price
    ON offers(price);

CREATE INDEX idx_offers_currency
    ON offers(currency);

CREATE INDEX idx_offers_stock
    ON offers(in_stock);

CREATE INDEX idx_offers_last_updated
    ON offers(last_updated);


-- ============================================================
-- 18. Indexes - Price History
-- ============================================================

CREATE INDEX idx_price_history_offer
    ON price_history(offer_id);

CREATE INDEX idx_price_history_recorded_at
    ON price_history(recorded_at);


-- ============================================================
-- 19. Indexes - Product Identifiers
-- ============================================================

CREATE INDEX idx_product_identifiers_product
    ON product_identifiers(product_id);

CREATE INDEX idx_product_identifiers_value
    ON product_identifiers(identifier_value);


-- ============================================================
-- 20. Indexes - Shipping
-- ============================================================

CREATE INDEX idx_offer_shipping_offer
    ON offer_shipping(offer_id);


-- ============================================================
-- 21. Indexes - Images
-- ============================================================

CREATE INDEX idx_product_images_product
    ON product_images(product_id);

CREATE INDEX idx_product_images_variant
    ON product_images(variant_id);


-- ============================================================
-- 22. Initial Stores
-- ============================================================

INSERT INTO stores
    (name, domain, homepage_url, country_code, currency)
VALUES
    ('Amazon.sa', 'amazon.sa', 'https://www.amazon.sa/', 'SA', 'SAR'),
    ('Noon', 'noon.com', 'https://www.noon.com/saudi-ar/', 'SA', 'SAR'),
    ('Temu', 'temu.com', 'https://www.temu.com/sa-en/', 'SA', 'SAR'),
    ('AliExpress', 'aliexpress.com', 'https://www.aliexpress.com/', 'CN', 'SAR'),
    ('eBay', 'ebay.com', 'https://www.ebay.com/', 'US', 'USD'),
    ('iHerb', 'iherb.com', 'https://sa.iherb.com/', 'SA', 'SAR'),
    ('SHEIN', 'shein.com', 'https://m.shein.com/ar/', 'SA', 'SAR'),
    ('Trendyol', 'trendyol.sa', 'https://www.trendyol.sa/', 'SA', 'SAR'),
    ('Nice One', 'niceonesa.com', 'https://niceonesa.com/en', 'SA', 'SAR'),
    ('Nahdi', 'nahdionline.com', 'https://www.nahdionline.com/', 'SA', 'SAR'),
    ('Al-Dawaa', 'al-dawaa.com', 'https://www.al-dawaa.com/', 'SA', 'SAR'),
    ('Spiro', 'spiro.sa', 'https://spiro.sa/', 'SA', 'SAR'),
    ('Namshi', 'namshi.com', 'https://www.namshi.com/saudi-ar/', 'SA', 'SAR'),
    ('6thStreet', '6thstreet.com', 'https://ar-sa.6thstreet.com/', 'SA', 'SAR'),
    ('Sephora', 'sephora.me', 'https://www.sephora.me/sa-ar?lang=ar', 'SA', 'SAR')
ON CONFLICT (domain) DO NOTHING;


-- ============================================================
-- 23. Initial Categories
-- ============================================================

INSERT INTO categories (name, slug)
VALUES
    ('إلكترونيات', 'electronics'),
    ('ملابس وأزياء', 'fashion'),
    ('أحذية', 'shoes'),
    ('جمال وعناية', 'beauty'),
    ('صحة وصيدلية', 'health'),
    ('قطع غيار سيارات', 'auto-parts'),
    ('مواد بناء', 'building-materials'),
    ('منزل', 'home'),
    ('أجهزة منزلية', 'home-appliances'),
    ('عطور', 'fragrance'),
    ('إكسسوارات', 'accessories'),
    ('منتجات عامة', 'general')
ON CONFLICT (slug) DO NOTHING;


-- ============================================================
-- 24. Useful Views
-- ============================================================

CREATE VIEW offer_price_summary AS
SELECT
    o.id AS offer_id,
    o.variant_id,
    o.store_id,
    o.seller_id,
    o.price,
    o.shipping_fee,
    (COALESCE(o.price, 0) + COALESCE(o.shipping_fee, 0)) AS total_price,
    o.currency,
    o.in_stock,
    o.external_url,
    o.last_updated
FROM offers o;


-- ============================================================
-- 25. Finalize
-- ============================================================

COMMIT;
