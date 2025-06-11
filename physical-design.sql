DROP DATABASE IF EXISTS pizzas_db;

CREATE DATABASE pizzas_db DEFAULT CHARACTER SET = 'utf8mb4';

USE pizzas_db;

CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE addresses (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    city VARCHAR(255) NOT NULL,
    street VARCHAR(255) NOT NULL,
    number VARCHAR(255) NOT NULL,
    unit VARCHAR(255) NULL,
    
    FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE payment_methods (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    type ENUM('credit_card', 'paypal') NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE credit_cards (
    payment_method_id INT UNSIGNED PRIMARY KEY,
    number VARCHAR(255) UNIQUE NOT NULL,
    expiration_date DATE NOT NULL,
    holder_name VARCHAR(255) NOT NULL,

    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE paypal_accounts (
    payment_method_id INT UNSIGNED PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,

    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE orders (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    address_id INT UNSIGNED NOT NULL,
    payment_method_id INT UNSIGNED NOT NULL,
    invoice_number VARCHAR(255) NOT NULL UNIQUE,
    total_price DECIMAL(8, 2) NOT NULL,
    status ENUM('pending', 'delivering', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (address_id) REFERENCES addresses (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE pizzas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    base_price DECIMAL(6, 2) NOT NULL,
    image VARCHAR(255) NOT NULL,
    description TEXT NULL
);

CREATE TABLE sizes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    price_multiplier DECIMAL(3, 2) NOT NULL
);

CREATE TABLE pizza_sizes (
    pizza_id INT UNSIGNED NOT NULL,
    size_id INT UNSIGNED NOT NULL,

    PRIMARY KEY (pizza_id, size_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (size_id) REFERENCES sizes (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE ingredients (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE pizza_ingredients (
    pizza_id INT UNSIGNED NOT NULL,
    ingredient_id INT UNSIGNED NOT NULL,

    PRIMARY KEY (pizza_id, ingredient_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Order and pizza relationship
CREATE TABLE order_pizzas (
    order_id INT UNSIGNED NOT NULL,
    pizza_id INT UNSIGNED NOT NULL,
    size_id INT UNSIGNED NOT NULL,
    price DECIMAL(6, 2) NOT NULL, -- pizza price at the time of the order
    quantity TINYINT UNSIGNED NOT NULL,

    PRIMARY KEY (order_id, pizza_id, size_id),
    FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (pizza_id) REFERENCES pizzas (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (size_id) REFERENCES sizes (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE drinks (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(5, 2) NOT NULL,
    size VARCHAR(255) NOT NULL,
    image VARCHAR(255) NOT NULL,
    description TEXT NULL
);

CREATE TABLE order_drinks (
    order_id INT UNSIGNED NOT NULL,
    drink_id INT UNSIGNED NOT NULL,
    price DECIMAL(5, 2) NOT NULL, -- drink price at the time of the order
    quantity TINYINT UNSIGNED NOT NULL,

    PRIMARY KEY (order_id, drink_id),
    FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (drink_id) REFERENCES drinks (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
