/* 
CTEs - Common Table Expressions
This query finds the top 5 most in-demand skills for remote Data Scientist job postings.

Steps:
- Use a CTE (remote_job_skills) to count the number of remote job postings requiring each skill.
- Filter only job postings with 'job_work_from_home' set to TRUE and job title equal to 'Data Scientist'.
- Join with the skills_dim table to retrieve skill names.
- Select skill ID, skill name, and the count of postings requiring the skill.
- Order results by demand (descending) and limit to the top 5 skills.
*/

WITH remote_job_skills AS
    (SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Scientist'
    GROUP BY
        skill_id
    )

SELECT
    skills.skill_id,
    skills.skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;