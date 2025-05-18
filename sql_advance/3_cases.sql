/*
Categorize job locations and count the number of 'Data Scientist' job postings per category.
Categories:
- 'Remote' if location is 'Anywhere'
- 'Local' if location is 'New York, NY'
- 'Onsite' for all other locations
*/

SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Scientist'
GROUP BY
    location_category;

