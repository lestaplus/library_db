-- Створення нової довідкової таблиці
CREATE TABLE IF NOT EXISTS Country (
    country_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Нормалізація Publisher
ALTER TABLE Publisher ADD COLUMN country_id INT;
ALTER TABLE Publisher DROP COLUMN country;
ALTER TABLE Publisher
    ADD CONSTRAINT fk_publisher_country
    FOREIGN KEY (country_id) REFERENCES Country(country_id) ON DELETE SET NULL;

-- Нормалізація Author
ALTER TABLE Author ADD COLUMN country_id INT;
ALTER TABLE Author DROP COLUMN country;
ALTER TABLE Author
    ADD CONSTRAINT fk_author_country
    FOREIGN KEY (country_id) REFERENCES Country(country_id) ON DELETE SET NULL;

-- Нормалізація Payment
ALTER TABLE Payment DROP COLUMN user_id;