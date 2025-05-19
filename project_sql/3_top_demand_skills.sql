/* 
Question: What are the most in-demand skills for data scientist?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data scientist.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/
SELECT 
    skills,
    COUNT(sjd.job_id) AS demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

/*
These are the top 5 most in-demand skills for Data Scientists based on all job postings:

- Python is the most requested skill with a demand count of 10,390.
- SQL ranks second with 7,488 mentions.
- R comes next with 4,674 mentions, highlighting its continued relevance in statistical analysis.
- AWS is in demand with 2,593 mentions, reflecting the industry's shift toward cloud-based infrastructure.
- Tableau appears 2,458 times, emphasizing the importance of data visualization capabilities.

[
  {
    "skills": "python",
    "demand_count": "10390"
  },
  {
    "skills": "sql",
    "demand_count": "7488"
  },
  {
    "skills": "r",
    "demand_count": "4674"
  },
  {
    "skills": "aws",
    "demand_count": "2593"
  },
  {
    "skills": "tableau",
    "demand_count": "2458"
  }
]
*/