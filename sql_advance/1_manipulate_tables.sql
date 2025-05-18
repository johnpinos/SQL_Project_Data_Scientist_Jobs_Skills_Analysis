-- Creating the 'job_applications' database (PostgreSQL)
CREATE DATABASE job_applications;

-- Create the 'job_applied' table to store information about job applications
CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

-- Insert initial job application records into the 'job_applied' table
INSERT INTO job_applied (
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES 
    (
        1,
        '2025-02-01',
        TRUE,
        'resume_01.pdf',
        TRUE,
        'cover_letter_01.pdf',
        'submitted'
    ),
    (
        2,
        '2025-02-05',
        FALSE,
        'resume_02.pdf',
        FALSE,
        NULL,
        'in_review'
    ),
    (
        3,
        '2025-02-10',
        TRUE,
        'resume_03.pdf',
        TRUE,
        'cover_letter_03.pdf',
        'rejected'
    );

-- Add a new column 'contact' to store the name of the contact person related to each application
ALTER TABLE job_applied
ADD contact VARCHAR(50);

-- Update contact names for each job application
UPDATE job_applied
SET contact = 'Jian Chan'
WHERE job_id = 1;

UPDATE job_applied 
SET contact = 'Monica Hall'
WHERE job_id = 2;

UPDATE job_applied 
SET contact = 'Jared Dunn'
WHERE job_id = 3;

-- Rename the 'contact' column to 'contact_name' for clarity
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

-- Change the data type of 'contact_name' from VARCHAR(50) to TEXT to allow longer names
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

-- Remove the 'contact_name' column from the table
ALTER TABLE job_applied
DROP COLUMN contact_name;

-- Drop the entire 'job_applied' table (use with caution; this deletes all data)
DROP TABLE job_applied;