🍕 Pizza Sales Analysis
This project contains SQL queries designed to analyze a pizza_db database. It aims to extract valuable insights from pizza sales data, covering aspects like total orders, revenue, popular pizza types and sizes, and more complex analytical questions.

🌟 Table of Contents
✨ About the Project

💡 Problem Solved

📊 Database Schema

🚀 Getting Started

📋 Prerequisites

📦 Setup

🤝 Contributing


✨ About the Project
This repository provides a collection of SQL queries that perform a comprehensive analysis of a pizza sales database. The goal is to answer various business questions, ranging from basic aggregations to more advanced analytical queries involving joins, subqueries, and window functions. These insights can help a pizza business understand its performance, popular items, and customer behavior.

💡 Problem Solved
Businesses often struggle to make data-driven decisions without a clear way to extract insights from their transactional data. This project offers pre-written, optimized SQL queries to quickly answer common business questions related to sales, popular products, and customer order patterns for a pizza business.

📊 Database Schema
The analysis is performed on a database named pizza_db which is assumed to have the following tables:

orders: Contains information about each order (e.g., order_id, date, time).

order_details: Contains details for each item in an order (e.g., order_details_id, order_id, pizza_id, quantity).

pizzas: Contains information about different pizza configurations (e.g., pizza_id, pizza_type_id, size, price).

pizza_types: Contains general information about pizza types (e.g., pizza_type_id, name, category, ingredients).

🚀 Getting Started
To run these queries, you'll need access to a MySQL database (or a similar SQL environment) with the pizza_db loaded.

📋 Prerequisites
A MySQL client or any SQL query tool (e.g., MySQL Workbench).

The pizza_db database loaded into your MySQL server. (You'll need to source the database schema and data if not already available).

📦 Setup
Ensure pizza_db is loaded: Before running the queries, make sure your MySQL server has the pizza_db database and all its tables (orders, order_details, pizzas, pizza_types) populated with data.

If you don't have the database, you would typically follow instructions from its source (e.g., pizza_db_schema.sql and pizza_db_data.sql files if provided).

Select the database: Open your SQL client and execute the following to select the correct database:

SQL

USE pizza_db;
Run the queries: Copy and paste the queries from pizza_sales_analysis.sql (or similar file name) into your SQL client and execute them.

🤝 Contributing
If you have suggestions for additional queries, optimizations, or found any issues, feel free to open an issue or submit a pull request. Contributions are always welcome!

Fork the repository.

Create your feature branch (git checkout -b feature/NewAnalysis).

Commit your changes (git commit -m 'Add new analysis for X').

Push to the branch (git push origin feature/NewAnalysis).

Open a Pull Request.
