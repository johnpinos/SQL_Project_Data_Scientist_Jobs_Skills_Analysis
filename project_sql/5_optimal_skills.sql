/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Scientist roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data scientist
*/
-- CTE #1: Calculate demand per skill by counting how many job postings require it
-- Use Query #3
WITH skills_demand AS( 
    SELECT 
        sjd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE
        job_title_short = 'Data Scientist' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY sjd.skill_id, sd.skills
), 
-- CTE #2: Calculate the average salary for each skill
-- Use Query #4
average_salary AS(
    SELECT 
        sjd.skill_id,
        sd.skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE
        job_title_short = 'Data Scientist'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY sjd.skill_id, sd.skills
)
-- Join both CTEs and return top 25 high-demand, high-paying skills
SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 10;

/*
Optimal Skills for Remote Data Scientist Roles:

 - Python stands out as the most in-demand skill (763 mentions) with a competitive average salary of $143,828, solidifying its status as the essential language in data science.
 - SQL also shows very high demand (591 mentions) and a strong average salary of $142,833, making it a key tool for database manipulation.
 - R maintains a considerable presence (394 mentions) with a solid average salary of $137,885, proving useful for advanced statistical analysis.
 - Tableau, although less in demand (219 mentions), offers an above-average salary ($146,970), making it a valuable tool for data visualization.
 - AWS and Azure, the leading cloud platforms, show a combination of good demand (217 and 122 mentions, respectively) and high salaries, especially AWS with an average of $149,630, reflecting its importance in modern data environments.
 - Spark, with 149 mentions and an average salary of $150,188, is a well-paid technology focused on processing large volumes of data.
 - TensorFlow and PyTorch, two leading machine learning frameworks, combine high salaries ($151,536 and $152,603, respectively) with solid technical demand (126 and 115 mentions), positioning themselves as key tools in predictive model development.
 - Pandas, while more modest in demand (113 mentions), offers a competitive salary of $144,816 and is essential for data analysis in Python.
 
Conclusion: Mastering a balanced stack of programming, ML, cloud, and visualization tools gives Data Scientists a strong competitive edge in remote roles.
[
  {
    "skill_id": 1,
    "skills": "python",
    "demand_count": "763",
    "avg_salary": "143828"
  },
  {
    "skill_id": 0,
    "skills": "sql",
    "demand_count": "591",
    "avg_salary": "142833"
  },
  {
    "skill_id": 5,
    "skills": "r",
    "demand_count": "394",
    "avg_salary": "137885"
  },
  {
    "skill_id": 182,
    "skills": "tableau",
    "demand_count": "219",
    "avg_salary": "146970"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "demand_count": "217",
    "avg_salary": "149630"
  },
  {
    "skill_id": 92,
    "skills": "spark",
    "demand_count": "149",
    "avg_salary": "150188"
  },
  {
    "skill_id": 99,
    "skills": "tensorflow",
    "demand_count": "126",
    "avg_salary": "151536"
  },
  {
    "skill_id": 74,
    "skills": "azure",
    "demand_count": "122",
    "avg_salary": "142306"
  },
  {
    "skill_id": 101,
    "skills": "pytorch",
    "demand_count": "115",
    "avg_salary": "152603"
  },
  {
    "skill_id": 93,
    "skills": "pandas",
    "demand_count": "113",
    "avg_salary": "144816"
  }
]
*/