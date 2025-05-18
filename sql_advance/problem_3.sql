/*  
Union Operator - First Quarter Job Postings with High Salaries

Objective:
- Combine job postings from the first quarter of 2023 (January to March).
- Filter results to show only 'Data Scientist' positions with an average yearly salary greater than $70,000.
- Display location, source, posting date, and salary.
*/

SELECT
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM(
SELECT *
FROM january_jobs

UNION ALL
SELECT *
FROM february_jobs

UNION ALL
SELECT *
FROM march_jobs
) AS q1_job_postings
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Scientist'
ORDER BY
    salary_year_avg DESC;