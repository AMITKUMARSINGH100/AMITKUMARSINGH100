create database Fraud_Detection;
use Fraud_Detection;

CREATE TABLE TRANSACTION (
    ID INT PRIMARY KEY,
    DATE DATE,
    AMOUNT DECIMAL(30,2),
    CARD INT,
    ID_MERCHANT INT,
    FOREIGN KEY (CARD) REFERENCES CREDIT_CARD(ID),
    FOREIGN KEY (ID_MERCHANT) REFERENCES MERCHANT(ID)
);


CREATE TABLE MERCHANT (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50),
    ID_MERCHANT_CATEGORY INT,
    FOREIGN KEY (ID_MERCHANT_CATEGORY) REFERENCES MERCHANT_CATEGORY(ID)
);


CREATE TABLE MERCHANT_CATEGORY (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50)
);

CREATE TABLE CARD_HOLDER (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50)
);

-- Q1. Find the total number of transactions and the total amount spent.
SELECT COUNT(id) AS total_transactions, ROUND(SUM(amount),0) AS total_amount
FROM transaction;

-- Q2. Identify the top 5 merchants with the highest transaction amounts.
SELECT id_merchant, ROUND(SUM(amount),0) AS total_amount
FROM transaction
GROUP BY id_merchant
ORDER BY total_amount DESC
LIMIT 5;

-- Q3. Find the average transaction amount for each card holder.
SELECT card, ROUND(AVG(amount),0) AS avg_transaction_amount
FROM transaction
GROUP BY card;

-- Q4. List the merchants where the total transaction amount exceeds a certain threshold (e.g., $10,000).
SELECT id_merchant, SUM(amount) AS total_amount
FROM transaction
GROUP BY id_merchant
HAVING total_amount > 1000;

-- Q5. Identify the card holders with the highest number of transactions.
SELECT card, COUNT(id) AS transaction_count
FROM transaction
GROUP BY card
ORDER BY transaction_count DESC
LIMIT 5;

-- Q6. Find the average transaction amount for each merchant category.
SELECT mc.id, mc.name, AVG(t.amount) AS avg_transaction_amount
FROM merchant_category mc
INNER JOIN merchant AS m ON mc.id = m.id_merchant_category
INNER JOIN transaction AS t ON m.id = t.id_merchant
GROUP BY mc.id, mc.name;

-- Q7. Identify transactions where the amount is significantly higher than the average transaction amount.
SELECT id, date, amount, card, id_merchant
FROM transaction
WHERE amount > (SELECT AVG(amount) * 2 FROM transaction);

-- Q8. List the card holders who made transactions at multiple merchants on the same day.
SELECT card, COUNT(DISTINCT id_merchant) AS unique_merchants_count
FROM transaction
GROUP BY card
HAVING unique_merchants_count > 1;

-- Q9. Find the top 3 merchant categories with the highest total transaction amounts.
SELECT mc.id, mc.name, SUM(t.amount) AS total_amount
FROM merchant_categories mc
JOIN merchants m ON mc.id = m.id_merchant_category
JOIN transactions t ON m.id = t.id_merchant
GROUP BY mc.id, mc.name
ORDER BY total_amount DESC
LIMIT 3;

-- Q10. Identify potential fraud by finding transactions with a significantly higher amount than the card holder's average.
SELECT t.id, t.date, t.amount, t.card, t.id_merchant
FROM transaction AS t
JOIN (SELECT card, AVG(amount) AS avg_amount FROM transaction GROUP BY card) AS card_avg ON t.card = card_avg.card
WHERE t.amount > card_avg.avg_amount * 3;