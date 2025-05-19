# Introduction
📊This project analyzes 💰 the highest paying jobs, 🔥 the most in-demand skills, and the intersection between the two factors in the field of data science.

🔍 SQL queries? Check out the corresponding repository here [project_sql folder](/project_sql/)

# Context
The objective of this analysis is to identify which technical skills offer the highest return in terms of salary and demand within the data science field, in order to support strategic decisions in professional development.

The data used is from Luke Barousse's [SQL Course](https://lukebarousse.com/sql) and has been adapted to focus specifically on Data Scientist roles.

### Key Questions
The SQL queries developed in this project aim to answer the following core questions:

1. What are the highest-paying Data Scientist positions?
2. What skills are required for these top-paying roles?
3. Which competencies are most in demand for Data Scientists today?
4. Which skills are associated with the highest average salaries?
5. Which skills are most strategic when considering both demand and compensation?

# Tools Used
To efficiently and systematically analyze the data science job market, the following tools were employed:

- **SQL:** The primary language for extracting, transforming, and analyzing job posting data.
- **PostgreSQL:** The database management system selected for its robustness, reliability, and widespread adoption in professional environments.
- **Visual Studio Code:** The development environment used to write and execute SQL queries, offering flexibility and strong extension support.
- **Git and GitHub:** Essential tools for version control, project documentation, and publishing the analysis in an organized and transparent manner.

# Analysis
Each of the questions posed in this project is intended to examine key aspects of the data science job market. Below is a breakdown of the approach used to address each of them:

### 1. Highest-Paid Data Scientist Positions
The top 10 highest-paying remote job positions for the role of *Data Scientist* were identified, considering only those listings that specify an annual salary.

```sql
SELECT
    jp.job_id,
    jp.job_title,
    c.name AS company_name,
    jp.job_location,
    jp.job_schedule_type,
    jp.salary_year_avg,
    jp.job_posted_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY job_title
            ORDER BY salary_year_avg DESC
        ) AS rn
    FROM job_postings_fact
    WHERE
        job_title_short = 'Data Scientist' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
) jp
LEFT JOIN company_dim c ON jp.company_id = c.company_id
WHERE rn = 1
ORDER BY salary_year_avg DESC
LIMIT 10;
```
Below is a breakdown of the highest-paying remote Data Scientist positions in 2023.
- **Salary range:** Between $300,000 and $550,000 USD per year.
- **Top companies:** Selby Jennings leads with two positions exceeding $500,000. Other notable companies include Algo Capital Group, Demandbase, Walmart, and Reddit.
- **Role diversity:** Positions range from *Staff Data Scientist* to *Director* and *Head of Data Science*, reflecting a broad spectrum of levels and specializations within the field.

![Top Paying Roles][assets\1_top_paying_roles.png] 
*Bar graph visualizing the salary for the top 10 salaries for data scientist; ChatGPT generated this graph from my SQL query results*

 ### 2. Skills Required in the Highest-Paying Data Scientist Jobs
To identify the key skills, I analyzed the 10 Data Scientist vacancies with the highest average salaries and extracted the competencies required in each.

```sql
WITH top_10_jobs AS (
    SELECT
        jp.job_id,
        jp.job_title,
        c.name AS company_name,
        jp.job_location,
        jp.job_schedule_type,
        jp.salary_year_avg,
        jp.job_posted_date
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY job_title
                ORDER BY salary_year_avg DESC
            ) AS rn
    FROM job_postings_fact
    WHERE
        job_title_short = 'Data Scientist' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
) jp
LEFT JOIN company_dim c ON jp.company_id = c.company_id
WHERE rn = 1
ORDER BY salary_year_avg DESC
LIMIT 10
)
SELECT
    t.job_id,
    t.job_title,
    t.company_name,
    t.salary_year_avg,
    s.skills
FROM top_10_jobs t
INNER JOIN skills_job_dim sj ON t.job_id = sj.job_id
INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
ORDER BY t.salary_year_avg DESC, t.job_id;
```
Below is a breakdown of the most in-demand skills in the top 10 highest-paying data scientist jobs in 2023.
- SQL and Python top the list, each mentioned in 7 postings.
- Java appears in 4 postings.
- Big Data technologies such as Apache Spark and Hadoop have a significant presence.
- Machine learning frameworks such as TensorFlow, PyTorch, Keras, and Scikit-learn are especially associated with leadership roles.
- Cloud platforms like AWS and GCP are required in at least 4 jobs.
- Other relevant skills include Tableau, Pandas, NumPy, Scala, and Kubernetes.

![Top Paying Skills][assets\2_top_paying_roles_skills.png]
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. Most In-Demand Skills for Data Scientists
To identify the most sought-after competencies in the job market, I analyzed all remote Data Scientist job postings. Based on this analysis, I extracted the five most frequent skills, providing insight into which tools and languages have the greatest practical value today.

```sql
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
```

Below is a breakdown of the most in-demand skills for data scientists in 2023.
- **Python** leads the ranking with 10,390 mentions, establishing itself as the essential tool in data science.
- **SQL** holds second place with 7,488 appearances, confirming its central role in data manipulation and extraction.
- **R** remains relevant with 4,674 mentions, being especially important for advanced statistical analysis.
- **AWS** stands out with 2,593 mentions, reflecting the growing demand for cloud infrastructure knowledge.
- **Tableau**, with 2,458 mentions, highlights the importance of data visualization for effective communication of results.

| skills    | demand_count |
|-----------|--------------|
| python    | 10,390       |
| sql       | 7,488        |
| r         | 4,674        |
| aws       | 2,593        |
| tableau   | 2,458        |

*Table of the demand for the top 5 skills in data scientist job postings*

### 4. Skills Based on Salary
The analysis of average salaries associated with different skills revealed which ones are the highest-paying for remote data scientists.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Below is a breakdown of the highest-paying skills for data scientists:
- **Experience in data privacy and compliance:** Skills such as GDPR lead with the highest salaries, reflecting the growing industry demand for knowledge in regulation and data protection.
- **Advanced programming and systems skills:** Languages and tools like Golang and OpenCV are highly valued, indicating high compensation for those proficient in backend development and computer vision.
- **Automation and project management tools:** Tools such as Selenium and the Atlassian suite (Jira, Confluence) are associated with higher salaries, emphasizing the value of automation and efficient workflow management in data science roles.

| Skills        | Average Salary ($) |
|---------------|--------------------|
| gdpr          | 217,738            |
| golang        | 208,750            |
| atlassian     | 189,700            |
| selenium      | 180,000            |
| opencv        | 172,500            |
| neo4j         | 171,655            |
| microstrategy | 171,147            |
| dynamodb      | 169,670            |
| php           | 168,125            |
| tidyverse     | 165,513            |

*Table of the average salary for the top 10 paying skills for data scientist*

### 5. Optimal Skills: High Demand and High Salary
This analysis identifies the most strategic skills for data scientists by combining two key criteria: high job demand and high average salary. The study focused exclusively on remote jobs with specified compensation

```sql
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
SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
Below is a breakdown of the optimal skills for data scientists that combine high demand and high salary:

- Specialized languages such as C and Go are among the highest-paid, exceeding $164,000 annually, although with lower demand. These skills correspond to more specialized technical roles.
- Cloud platforms and orchestration tools like Airflow, GCP, Snowflake, and BigQuery stand out both for their salary and popularity, making them solid bets for professional growth.
- Machine learning tools such as TensorFlow, PyTorch, and Scikit-learn combine high demand with competitive salaries, reflecting their widespread use in the field.
- Python stands out for its combination of extremely high demand (763 mentions) and competitive salary, consolidating itself as the essential language for any data scientist.

| Skills         | Demand Count | Average Salary ($)    |
|----------------|--------------|-----------------------|
| python         | 763          | 143,828               |
| tableau        | 219          | 146,970               |
| aws            | 217          | 149,630               |
| tensorflow     | 126          | 151,536               |
| pandas         | 113          | 144,816               |
| pytorch        | 115          | 152,603               |
| scikit-learn   | 81           | 148,964               |
| numpy          | 73           | 149,089               |
| snowflake      | 72           | 152,687               |
| gcp            | 59           | 155,811               |

*Table of the most optimal skills for data scientist sorted by salary*

# Conclusions
This project enabled the extraction of key insights about the data science job market, with a particular focus on remote positions. Based on the analysis, the following conclusions stand out:

1. **Demand vs. compensation:** Not all high-demand skills are the highest paid. Some, although less popular, offer high profitability.
2. **Essential languages:** Python is established as the indispensable language. SQL remains relevant in nearly every job posting.
3.  **Emerging trends:** Cloud infrastructure, data orchestration, and automation are rising in both demand and salary.
4. **Technical specialization:** Mastering specific technical tools can open opportunities in better-paid and less competitive roles.
5. **Strategic recommendation:** It is advisable to combine widely used skills (Python, SQL) with high-value specializations (cloud, machine learning, automation).

This analysis provides an objective and actionable foundation for planning a professional development path in data science.

# What I Learned
Throughout this project, I strengthened my data analysis skills using SQL, focusing on real-world labor market scenarios:

- 🧠 **Advanced queries:** Use of CTEs, subqueries, and multiple JOIN operations to build complex and modular analyses.
- 📊 **Grouping and aggregation:** Application of functions like COUNT(), AVG(), ROUND(), and GROUP BY.
- 🔍 **Applied analytical thinking:** Ability to translate strategic questions into precise SQL queries.
- 📈 **Data-driven interpretation:** Critical identification of patterns and trends relevant to decision-making.





[assets\1_top_paying_roles.png]: assets/1_top_paying_roles.png
[assets\2_top_paying_roles_skills.png]: assets/2_top_paying_roles_skills.png