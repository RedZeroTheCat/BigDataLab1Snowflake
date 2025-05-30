-- По исходной таблице можно выделить конкретные измерения,
-- по которым можно создать отдельные таблицы

-- Покупатели
create table if not exists customers (
    customer_id SERIAL primary key,
    first_name TEXT,
    last_name TEXT,
    age INT,
    email TEXT unique,
    country TEXT,
    postal_code TEXT,
    pet_type TEXT,
    pet_name TEXT,
    pet_breed TEXT,
    pet_category TEXT
);

-- Продавцы
create table if not exists sellers (
    seller_id SERIAL primary key,
    first_name TEXT,
    last_name TEXT,
    email TEXT unique,
    country TEXT,
    postal_code TEXT
);

-- Товары
create table if not exists products (
    product_id SERIAL primary key,
    name TEXT,
    category TEXT,
    price NUMERIC,
    weight NUMERIC,
    color TEXT,
    size TEXT,
    brand TEXT,
    material TEXT,
    description TEXT,
    rating NUMERIC,
    reviews INT,
    release_date DATE,
    expiry_date DATE
);

-- Магазины
create table if not exists stores (
    store_id SERIAL primary key,
    name TEXT,
    location TEXT,
    city TEXT,
    state TEXT,
    country TEXT,
    phone TEXT,
    email TEXT
);

-- Поставщики
create table if not exists suppliers (
    supplier_id SERIAL primary key,
    name TEXT,
    contact TEXT,
    email TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    country TEXT
);


-- Факт - продажа предметов, поэтому таблица фактов следующая:
create table if not exists sales_fact (
    sale_id SERIAL primary key,
    sale_date DATE,
    quantity INT,
    total_price NUMERIC,
    customer_id INT references customers(customer_id),
    seller_id INT references sellers(seller_id),
    product_id INT references products(product_id),
    store_id INT references stores(store_id),
    supplier_id INT references suppliers(supplier_id)
);


-- Заполняем таблицы данными на основе исходной таблицы
insert into customers (first_name, last_name, age, email, country, postal_code,
                          pet_type, pet_name, pet_breed, pet_category)
select distinct
    customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type,
    customer_pet_name, customer_pet_breed, pet_category
from mock_data;

insert into sellers (first_name, last_name, email, country, postal_code)
select distinct
    seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code
from mock_data;

insert into products (name, category, price, weight, color, size, brand, material,
                         description, rating, reviews, release_date, expiry_date)
select distinct
    product_name, product_category, product_price, product_weight, product_color,
    product_size, product_brand, product_material, product_description,
    product_rating, product_reviews, product_release_date, product_expiry_date
from mock_data;

insert into stores (name, location, city, state, country, phone, email)
select distinct
    store_name, store_location, store_city, store_state,
    store_country, store_phone, store_email
from mock_data;

insert into suppliers (name, contact, email, phone, address, city, country)
select distinct
    supplier_name, supplier_contact, supplier_email, supplier_phone,
    supplier_address, supplier_city, supplier_country
from mock_data;



insert into sales_fact (sale_date, 
						quantity, 
						total_price, 
						customer_id, 
						seller_id,
                        product_id, 
                        store_id, 
                        supplier_id)
select
    md.sale_date,
    md.sale_quantity,
    md.sale_total_price,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sp.supplier_id
from mock_data md
join customers c on
    md.customer_first_name = c.first_name and
    md.customer_last_name = c.last_name and
    md.customer_email = c.email
join sellers s on
    md.seller_first_name = s.first_name AND
    md.seller_last_name = s.last_name AND
    md.seller_email = s.email
join products p on
    md.product_name = p.name and
    md.product_category = p.category and
    md.product_brand = p.brand and
    md.product_size = p.size
join stores st on
    md.store_name = st.name and
    md.store_city = st.city and
    md.store_country = st.country
join suppliers sp on
    md.supplier_name = sp.name and
    md.supplier_email = sp.email and
    md.supplier_phone = sp.phone;

                        
                        
                        







