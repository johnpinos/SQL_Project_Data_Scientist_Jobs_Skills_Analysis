-- SubQuery Practice:
-- Retrieves all job postings from January by using a subquery

SELECT *
FROM ( --subQuery start here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) =1
) AS january_jobs; -- subQuery ends here

-- CTE (Common Table Expressions) Practice:
-- Defines a CTE to filter job postings from January, then selects from it

WITH january_jobs AS ( --CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) =1
) -- CTE definition ends here

/*
Filter companies that have at least one job posting without a degree requirement
- Retrieves company ID and name from the company_dim table
- Filters using a subquery that returns company IDs from job postings where no degree is mentioned
*/

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN(
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = true
);

/*
Retrieve total job postings per company using a CTE
- Step 1: Count total job postings per company (CTE)
- Step 2: Join the result with company_dim to get the company name
- Step 3: Order the final result by job count in descending order
*/

WITH company_job_count AS(
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;