/* 
Create Tables from Existing Table (job_postings_fact)

Objective:
- Create three new tables containing job postings for each of the first three months of 2023.

Details:
- Use CREATE TABLE AS to create a new table based on a SELECT query.
- Filter by month using the EXTRACT(MONTH FROM date_column) function.
*/

--January
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 AND EXTRACT(YEAR FROM job_posted_date) = 2023;

--February
CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2 AND EXTRACT(YEAR FROM job_posted_date) = 2023;

--March
CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3 AND EXTRACT(YEAR FROM job_posted_date) = 2023;
