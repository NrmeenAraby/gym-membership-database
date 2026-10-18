# Gym Membership Database

A relational database project built with Oracle SQL to manage gym members, membership plans, memberships, trainers, fitness classes, class bookings, and payments.

## Database Design

### Entity-Relationship Diagram (ERD)

<img width="920" height="551" alt="image" src="https://github.com/user-attachments/assets/532cc438-1ef5-4f77-b0e2-b30198b2a84e" />


### Relational Schema

<img width="486" height="618" alt="image" src="https://github.com/user-attachments/assets/834307f9-2ad3-4eb8-93db-7e89c53d49ce" />


## Implementation

The database is implemented using Oracle-compatible SQL, with:

- Primary and foreign key constraints
- Required-field and `CHECK` constraints
- Identity columns and default values
- Sample data covering different scenarios, including members without memberships, plans without memberships, trainers without classes, classes without bookings, and payments with different statuses

## SQL Queries

The project includes 15 queries covering:

- `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN`
- Aggregation using `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`
- `GROUP BY`, `HAVING`, and `ORDER BY`
- Conditional labels using `CASE`
- Handling missing values using `COALESCE` and `NVL`
- Filtering and summarizing payment and booking data

## How to Run

1. Open `sql/gym_management.sql` in Oracle SQL Developer.
2. Connect to your Oracle database using a schema where you can create and manage tables.
3. Run the script to create the tables, insert sample records, and execute the queries.

**Note:** The script begins with `DROP TABLE` statements to reset existing project tables. Run it only in the intended schema.

## Tools

- Oracle SQL
- Oracle SQL Developer
