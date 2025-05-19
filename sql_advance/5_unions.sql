-- UNION
-- Combine job title, company ID, and job location from January, February, and March jobs
-- Removes duplicate rows across the three tables
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

-- UNION ALL
-- Combine job title, company ID, and job location from January, February, and March jobs
-- Includes all rows, including duplicates
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;