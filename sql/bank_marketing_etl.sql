SELECT *
FROM `bank-additional-full`;

CREATE TABLE bank_additional_staging
LIKE `bank-additional-full`;

INSERT bank_additional_staging
SELECT *
FROM `bank-additional-full`;

SELECT *
FROM bank_additional_staging;



WITH duplicates_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY
age, job, marital, education, `default`, housing, loan, contact, `month`, day_of_week, duration,
campaign, pdays, previous, poutcome, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, euribor3m, `nr.employed`)
AS row_num
FROM bank_additional_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;


ALTER TABLE bank_additional_staging
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE bank_additional_staging
ADD COLUMN row_num INT;

UPDATE bank_additional_staging AS t1
JOIN(
	SELECT id,
    ROW_NUMBER() OVER(PARTITION BY
	age, job, marital, education, `default`, housing, loan, contact, `month`, day_of_week, duration,
	campaign, pdays, previous, poutcome, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, euribor3m, `nr.employed`)
	AS row_num
    FROM bank_additional_staging
) AS t2
ON t1.id = t2.id
SET t1.row_num = t2.row_num;


SELECT *
FROM bank_additional_staging
WHERE row_num > 1;

DELETE
FROM bank_additional_staging
WHERE row_num > 1;







CREATE TABLE bank_additional_staging2
LIKE bank_additional_staging;

INSERT bank_additional_staging2
SELECT *
FROM bank_additional_staging;

SELECT *
FROM bank_additional_staging2
WHERE row_num > 1;








    


SELECT DISTINCT job, LENGTH(job)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET job = LOWER(job);


SELECT DISTINCT marital, LENGTH(marital)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET marital = LOWER(marital);


SELECT DISTINCT education, LENGTH(education)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET education = LOWER(education);


SELECT DISTINCT `default`, LENGTH(`default`)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET `default` = LOWER(`default`);


SELECT DISTINCT housing, LENGTH(housing)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET housing = LOWER(housing);


SELECT DISTINCT loan, LENGTH(loan)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET loan = LOWER(loan);


SELECT DISTINCT contact, LENGTH(contact)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET contact = LOWER(contact);


SELECT DISTINCT `month`, LENGTH(`month`)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET `month` = LOWER(`month`);


SELECT DISTINCT day_of_week, LENGTH(day_of_week)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET day_of_week = LOWER(day_of_week);


SELECT DISTINCT poutcome, LENGTH(poutcome)
FROM bank_additional_staging2
ORDER BY 1;

UPDATE bank_additional_staging2
SET poutcome = LOWER(poutcome);





ALTER TABLE bank_additional_staging2
ADD COLUMN financial_stress INT,
ADD COLUMN unknown_count INT;


UPDATE bank_additional_staging2
SET financial_stress = 
    (CASE WHEN `default` = 'yes' THEN 1 ELSE 0 END) +
    (CASE WHEN housing = 'yes' THEN 1 ELSE 0 END) +
    (CASE WHEN loan = 'yes' THEN 1 ELSE 0 END);
    

UPDATE bank_additional_staging2
SET unknown_count = 
    (CASE WHEN `default` = 'unknown' THEN 1 ELSE 0 END) +
    (CASE WHEN housing = 'unknown' THEN 1 ELSE 0 END) +
    (CASE WHEN loan = 'unknown' THEN 1 ELSE 0 END);
    

SELECT `default`, housing, loan, financial_stress, unknown_count
FROM bank_additional_staging2
WHERE unknown_count = 3;




ALTER TABLE bank_additional_staging2
ADD COLUMN contact_intensity INT;

UPDATE bank_additional_staging2
SET contact_intensity = campaign + previous;

SELECT campaign, previous, contact_intensity
FROM bank_additional_staging2;




ALTER TABLE bank_additional_staging2
ADD COLUMN economic_index FLOAT;

UPDATE bank_additional_staging2
SET economic_index = `emp.var.rate` + `cons.conf.idx` + euribor3m;

SELECT `emp.var.rate`, `cons.conf.idx`, euribor3m, economic_index
FROM bank_additional_staging2;


SELECT *
FROM bank_additional_staging2;









