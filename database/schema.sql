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
