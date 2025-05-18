-- Creating the 'sql_course' database (PostgreSQL)
CREATE DATABASE sql_course; -- loading process (sql_load folder)

-- Selects job title, location, and the posted date (cast as DATE) from the job postings table
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM 
    job_postings_fact;

-- Selects job title, location, and posted date converted from UTC to EST timezone
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM 
    job_postings_fact;

-- Selects job title, location, the posted date converted to EST, and extracts month and year components
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM 
    job_postings_fact;

-- Counts the number of 'Data Scientist' job postings by month, ordered by highest posting count
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Scientist'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;
