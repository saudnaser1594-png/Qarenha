CREATE TABLE stores (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    domain VARCHAR(255) NOT NULL UNIQUE,
    homepage_url TEXT NOT NULL,
    country_code VARCHAR(2) DEFAULT 'SA',
    currency VARCHAR(3) DEFAULT 'SAR',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    slug VARCHAR(150) NOT NULL UNIQUE,
    parent_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    brand VARCHAR(150),
    model VARCHAR(150),
    model_number VARCHAR(150),
    barcode VARCHAR(100),
    sku VARCHAR(150),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

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

CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    sku VARCHAR(150),
    variant_name VARCHAR(255),
    color VARCHAR(100),
    size VARCHAR(100),
    storage VARCHAR(100),
    ram VARCHAR(100),
    processor VARCHAR(150),
    attributes JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_product_variants_product
    ON product_variants(product_id);

CREATE INDEX idx_product_variants_sku
    ON product_variants(sku);

CREATE INDEX idx_product_variants_attributes
    ON product_variants USING GIN(attributes);

CREATE TABLE sellers (
    id BIGSERIAL PRIMARY KEY,
    store_id BIGINT NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
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

CREATE INDEX idx_sellers_store
    ON sellers(store_id);

CREATE INDEX idx_sellers_external_id
    ON sellers(external_seller_id);

CREATE TABLE offers (
    id BIGSERIAL PRIMARY KEY,
    variant_id BIGINT NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    store_id BIGINT NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    seller_id BIGINT REFERENCES sellers(id) ON DELETE SET NULL,

    external_product_id VARCHAR(255),
    external_offer_id VARCHAR(255),
    external_url TEXT NOT NULL,

    price NUMERIC(12,2),
    shipping_fee NUMERIC(12,2) DEFAULT 0,
    currency VARCHAR(3) NOT NULL DEFAULT 'SAR',

    in_stock BOOLEAN,
    availability_text VARCHAR(255),

    last_updated TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_offers_variant
    ON offers(variant_id);

CREATE INDEX idx_offers_store
    ON offers(store_id);

CREATE INDEX idx_offers_seller
    ON offers(seller_id);

CREATE INDEX idx_offers_price
    ON offers(price);

CREATE INDEX idx_offers_last_updated
    ON offers(last_updated);
