CREATE DATABASE loan_analysis;
use loan_analysis;
SELECT COUNT(*) AS Total_loans
FROM credit_risk;

SELECT
    SUM(Person_age IS NULL) AS null_age,
    SUM(Person_income IS NULL) AS null_income,
    SUM(Person_home_ownership IS NULL) AS null_home_ownership,
    SUM(Person_emp_length IS NULL) AS null_emp_length,
    SUM(Loan_intent IS NULL) AS null_loan_intent,
    SUM(Loan_grade IS NULL) AS null_loan_grade,
    SUM(Loan_amnt IS NULL) AS null_loan_amount,
    SUM(Loan_int_rate IS NULL) AS null_interest_rate,
    SUM(Loan_status IS NULL) AS null_loan_status,
    SUM(Loan_percent_income IS NULL) AS null_loan_percent_income,
    SUM(CB_person_default_on_file IS NULL) AS null_previous_default,
    SUM(CB_person_cred_hist_length IS NULL) AS null_credit_history
FROM credit_risk; 

SELECT COUNT(*) AS Total_loans,
SUM(Loan_amnt) AS Total_loan_amount,
AVG(Loan_amnt) AS Average_loan_amount,
MIN(Loan_amnt) AS Min_loan_amount,
MAX(Loan_amnt) AS Max_loan_amount,
AVG(Person_income) AS Average_income,
AVG(Loan_int_rate) AS Average_intrest_rate
FROM credit_risk;

SELECT
CASE
WHEN Person_emp_length IS NULL THEN 'Unknown'
WHEN Person_emp_length < 2 THEN '0-1 Years'
WHEN Person_emp_length < 5 THEN '2-4 Years'
WHEN Person_emp_length < 10 THEN '5-9 Years'
ELSE '10+ Years'
END AS employment_band,
COUNT(*) AS total_loans,
SUM(Loan_status) AS defaulted_loans,
ROUND(100.0 * SUM(Loan_status) / COUNT(*),2) AS default_rate_pct
FROM credit_risk
GROUP BY
CASE
WHEN Person_emp_length IS NULL THEN 'Unknown'
WHEN Person_emp_length < 2 THEN '0-1 Years'
WHEN Person_emp_length < 5 THEN '2-4 Years'
WHEN Person_emp_length < 10 THEN '5-9 Years'
ELSE '10+ Years'
END
ORDER BY default_rate_pct DESC;

SELECT
    Loan_grade,
    COUNT(*) AS total_loans,
    SUM(Loan_int_rate IS NULL) AS missing_interest_rate,
    ROUND(100.0 * SUM(Loan_int_rate IS NULL) / COUNT(*),2) AS missing_pct
FROM credit_risk
GROUP BY Loan_grade
ORDER BY missing_interest_rate DESC;

SELECT
CASE
WHEN Loan_int_rate IS NULL THEN 'Missing'
ELSE 'Available'
END AS interest_rate_status,
COUNT(*) AS total_loans,
SUM(Loan_status) AS defaulted_loans,
ROUND(100.0 * SUM(Loan_status) / COUNT(*),2) AS default_rate_pct
FROM credit_risk
GROUP BY interest_rate_status;

WITH loan_data AS (SELECT *,
CASE
WHEN Loan_status = 1 THEN 1 ELSE 0
END AS default_flag
FROM credit_risk
)
SELECT * FROM loan_data
LIMIT 10;


SELECT COUNT(*) AS Total_loans,
SUM(CASE 
WHEN Loan_status=1 THEN 1 ELSE 0
END) AS Defaulted_loans,
Round(100* SUM(CASE
WHEN Loan_status=1 THEN 1 ELSE 0 END)/COUNT(*),2) AS Default_rate_pct
FROM credit_risk;

SELECT
CASE
WHEN Loan_status=1 THEN 'Default' ELSE 'Non-Default' END AS Loan_result,

COUNT(*) AS Loan_result,

SUM(Loan_amnt) AS Total_loan_amount,

ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS Portfolio_share_pct
FROM credit_risk
GROUP BY Loan_status;


-- ANALYSIS-- 

--  1. Default rate by Loan Intent 

SELECT Loan_intent,
COUNT(*) AS Total_loans,

SUM(Loan_status) AS Defaulted_loan,

ROUND(100*SUM(Loan_status)/count(*),2) AS Default_rate_pct,

SUM(Loan_amnt) AS Total_loan_amount,

ROUND(AVG(Loan_amnt),2) AS Avg_loan_amount

FROM credit_risk
GROUP BY Loan_intent
ORDER BY Default_rate_pct DESC;

SELECT Person_home_ownership,
COUNT(*) AS Total_loans,

SUM(Loan_status) AS Defaulted_loan,

ROUND(100*SUM(Loan_status)/count(*),2) AS Default_rate_pct,

SUM(Loan_amnt) AS Total_loan_amount,

ROUND(AVG(Loan_amnt),2) AS Avg_loan_amount

FROM credit_risk
GROUP BY Person_home_ownership
ORDER BY Default_rate_pct DESC;


SELECT Loan_grade,
COUNT(*) AS Total_loans,

SUM(Loan_status) AS Defaulted_loan,

ROUND(100*SUM(Loan_status)/count(*),2) AS Default_rate_pct,

SUM(Loan_amnt) AS Total_loan_amount,

ROUND(AVG(Loan_amnt),2) AS Avg_loan_amount

FROM credit_risk
GROUP BY Loan_grade
ORDER BY Default_rate_pct DESC;


SELECT CB_person_default_on_file,
COUNT(*) AS Total_loans,

SUM(Loan_status) AS Defaulted_loan,

ROUND(100*SUM(Loan_status)/count(*),2) AS Default_rate_pct,

SUM(Loan_amnt) AS Total_loan_amount,

ROUND(AVG(Loan_amnt),2) AS Avg_loan_amount

FROM credit_risk
GROUP BY CB_person_default_on_file
ORDER BY Default_rate_pct DESC;


WITH age_groups AS(
SELECT*,
CASE
WHEN Person_age <25 THEN 'Under 25'
WHEN Person_age BETWEEN 25 AND 34  THEN '25-34'
WHEN Person_age BETWEEN 34 AND 44  THEN '34-44'
WHEN Person_age BETWEEN 44 AND 54  THEN '44-54'
ELSE '55+'
END AS age_group
FROM credit_risk)
SELECT age_group,
COUNT(*) AS Total_loans,

SUM(Loan_status) AS Defaulted_loan,

ROUND(100*SUM(Loan_status)/count(*),2) AS Default_rate_pct,

SUM(Loan_amnt) AS Total_loan_amount,

ROUND(AVG(Loan_amnt),2) AS Avg_loan_amount

FROM age_groups
GROUP BY age_group
ORDER BY Default_rate_pct DESC;



WITH Income_groups AS(
SELECT*,
CASE
WHEN Person_income <30000 THEN 'low income'
WHEN Person_income <60000 THEN 'lower-middle income'
WHEN Person_income <100000 THEN 'middle income'
ELSE 'high income'
END AS income_group
FROM credit_risk)
SELECT income_group,
COUNT(*) AS Total_loans,
SUM(Loan_status) AS Defaulted_loan,
ROUND(100*SUM(Loan_status)/count(*),2) AS Default_rate_pct,
SUM(Loan_amnt) AS Total_loan_amount,
ROUND(AVG(Loan_amnt),2) AS Avg_loan_amount
FROM Income_groups
GROUP BY income_group
ORDER BY Default_rate_pct DESC;

WITH interest_groups AS(
SELECT*,
CASE
WHEN Loan_int_rate IS NULL THEN 'Missing_rate'
WHEN Loan_int_rate < 8 THEN 'Below 8%'
WHEN Loan_int_rate < 12 THEN '8%-12%'
WHEN Loan_int_rate < 16 THEN '12%-16%'
ELSE '16+'
END AS interest_rate_group
FROM credit_risk)
SELECT interest_rate_group,
COUNT(*) AS Toatal_loans,
SUM(Loan_status) AS Defaulted_loan,
ROUND(100*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct
FROM interest_groups
GROUP BY interest_rate_group
ORDER BY Default_rate_pct DESC;

WITH Loan_amount_groups AS(
SELECT*,
CASE
WHEN Loan_amnt < 5000 THEN 'Below 5k'
WHEN Loan_amnt < 10000 THEN '5k-10k'
WHEN Loan_amnt < 20000 THEN '10k-20k'
ELSE '20k+'
END AS Loan_amount_group
FROM credit_risk)
SELECT Loan_amount_group,
COUNT(*) AS Total_loans,
SUM(Loan_status) AS Defaulted_loan,
ROUND(100*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct
FROM Loan_amount_groups
GROUP BY Loan_amount_group
ORDER BY Default_rate_pct DESC;


WITH Income_burden AS(
SELECT*,
CASE
WHEN Loan_percent_income < 0.10 THEN 'Below 10%'
WHEN Loan_percent_income < 0.20 THEN '10%-20%'
WHEN Loan_percent_income < 0.30 THEN '20%-30%'
ELSE '30%+'
END AS Income_burden_group
FROM credit_risk)
SELECT Income_burden_group,
COUNT(*) AS Total_loans,
SUM(Loan_status) AS Defaulted_loan,
ROUND(100*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct
FROM Income_burden
GROUP BY Income_burden_group
ORDER BY Default_rate_pct DESC;


WITH Credit_history_groups AS(
SELECT*,
CASE
WHEN CB_person_cred_hist_length < 5 THEN '0-5 years'
WHEN CB_person_cred_hist_length < 10 THEN '5-10 years'
WHEN CB_person_cred_hist_length < 15 THEN '10-15 years'
ELSE '15+ years'
END AS Credit_history_group
FROM credit_risk)
SELECT Credit_history_group,
COUNT(*) AS Total_loans,
SUM(Loan_status) AS Defaulted_loan,
ROUND(100*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct
FROM Credit_history_groups
GROUP BY Credit_history_group
ORDER BY Default_rate_pct DESC;


WITH Income_burden AS(
SELECT*,
CASE
WHEN Loan_percent_income < 0.10 THEN 'Below 10%'
WHEN Loan_percent_income < 0.20 THEN '10%-20%'
WHEN Loan_percent_income < 0.30 THEN '20%-30%'
ELSE '30+ years'
END AS Income_burden_group
FROM credit_risk)
SELECT Income_burden_group,
COUNT(*) AS Total_loans,
SUM(Loan_status) AS Defaulted_loan,
ROUND(100*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct
FROM Income_burden
GROUP BY Income_burden_group
ORDER BY Default_rate_pct DESC;


SELECT
    CASE
        WHEN Loan_status = 1 THEN 'Default'
        ELSE 'Non-Default'
    END AS loan_result,
    COUNT(*) AS total_loans,
    ROUND(AVG(Person_income), 2) AS avg_income,
    ROUND(AVG(Loan_amnt), 2) AS avg_loan_amount,
    ROUND(AVG(Loan_int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(Person_emp_length), 2) AS avg_employment_length,
    ROUND(AVG(CB_person_cred_hist_length), 2) AS avg_credit_history,
    ROUND(AVG(Loan_percent_income), 3) AS avg_loan_income_ratio
FROM credit_risk
GROUP BY Loan_status;

SELECT Loan_grade,CB_person_default_on_file AS previous_default,
COUNT(*) AS Total_loanS,
SUM(Loan_status) AS Default_loans,
ROUND(100.0*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct,
SUM(Loan_amnt) AS Total_loan_amount
FROM credit_risk
GROUP BY Loan_grade,CB_person_default_on_file
HAVING COUNT(*) >= 50
ORDER BY Default_rate_pct DESC;

SELECT Loan_grade,Loan_intent,
COUNT(*) AS Total_loans,
SUM(Loan_status) AS Default_loans,
ROUND(100.0*SUM(Loan_status)/COUNT(*),2) AS Default_rate_pct,
SUM(Loan_amnt) AS Total_loan_amount
FROM credit_risk
GROUP BY Loan_grade,Loan_intent
HAVING COUNT(*) >= 50
ORDER BY Default_rate_pct DESC;

SELECT Loan_grade,
    COUNT(*) AS total_loans,
    SUM(Loan_amnt) AS total_exposure,
    SUM(
        CASE
            WHEN Loan_status = 1 THEN Loan_amnt ELSE 0 END) AS defaulted_exposure,
    ROUND(
        100.0 * SUM(Loan_status) / COUNT(*),2) AS default_rate_pct
FROM credit_risk
GROUP BY Loan_grade
ORDER BY defaulted_exposure DESC;

SELECT Person_home_ownership,
    COUNT(*) AS total_loans,
    SUM(Loan_amnt) AS total_exposure,
    SUM(
        CASE
            WHEN Loan_status = 1 THEN Loan_amnt ELSE 0 END) AS defaulted_exposure,
    ROUND(
        100.0 * SUM(Loan_status) / COUNT(*),2) AS default_rate_pct
FROM credit_risk
GROUP BY Person_home_ownership
ORDER BY defaulted_exposure DESC;

WITH segment_risk AS (
SELECT
Loan_grade,
COUNT(*) AS total_loans,
SUM(Loan_amnt) AS total_exposure,
SUM(
CASE
WHEN Loan_status = 1 THEN Loan_amnt ELSE 0 END) AS defaulted_exposure,
100.0 * SUM(Loan_status) / COUNT(*) AS default_rate_pct

FROM credit_risk
GROUP BY Loan_grade),

portfolio_average AS (
SELECT
AVG(default_rate_pct) AS avg_default_rate,
AVG(total_exposure) AS avg_exposure
FROM segment_risk)

SELECT
s.Loan_grade,
s.total_loans,
ROUND(s.default_rate_pct, 2) AS default_rate_pct,
s.total_exposure,
s.defaulted_exposure,
CASE
WHEN s.default_rate_pct >= p.avg_default_rate AND s.total_exposure >= p.avg_exposure THEN 'High Risk + High Exposure'
WHEN s.default_rate_pct >= p.avg_default_rate AND s.total_exposure < p.avg_exposure THEN 'High Risk + Low Exposure'
WHEN s.default_rate_pct < p.avg_default_rate AND s.total_exposure >= p.avg_exposure THEN 'Low Risk + High Exposure'
ELSE 'Low Risk + Low Exposure'
END AS risk_exposure_category

FROM segment_risk s
CROSS JOIN portfolio_average p
ORDER BY s.default_rate_pct DESC;


--  RISK + EXPOSURE RANKING BY LOAN GRADE

WITH segment_analysis AS (
SELECT
Loan_grade,
COUNT(*) AS total_loans,
SUM(Loan_status) AS defaulted_loans,
ROUND(100.0 * SUM(Loan_status) / COUNT(*), 2) AS default_rate_pct,
SUM(Loan_amnt) AS total_exposure,
SUM(
CASE
WHEN Loan_status = 1 THEN Loan_amnt ELSE 0 END) AS defaulted_exposure
FROM credit_risk
GROUP BY Loan_grade),

ranked_segments AS (
SELECT*,
RANK() OVER (ORDER BY default_rate_pct DESC) AS default_rate_rank,
RANK() OVER (ORDER BY defaulted_exposure DESC) AS defaulted_exposure_rank
FROM segment_analysis)
SELECT
    Loan_grade,
    total_loans,
    defaulted_loans,
    default_rate_pct,
    total_exposure,
    defaulted_exposure,
    default_rate_rank,
    defaulted_exposure_rank,

CASE
WHEN default_rate_rank = 1 AND defaulted_exposure_rank = 1 THEN 'Highest Risk + Highest Exposure'
WHEN default_rate_rank = 1 THEN 'Highest Default Rate'
WHEN defaulted_exposure_rank = 1 THEN 'Highest Defaulted Exposure'
ELSE 'Other'
END AS risk_priority

FROM ranked_segments
ORDER BY default_rate_rank;

WITH segment_analysis AS (
SELECT
Loan_intent,
Loan_grade,
COUNT(*) AS total_loans,
SUM(Loan_status) AS defaulted_loans,
ROUND(100.0 * SUM(Loan_status) / COUNT(*),2) AS default_rate_pct,
SUM(Loan_amnt) AS total_exposure,
SUM(
CASE
WHEN Loan_status = 1 THEN Loan_amnt ELSE 0 END) AS defaulted_exposure
FROM credit_risk
GROUP BY Loan_intent,Loan_grade
HAVING COUNT(*) >= 50
),

ranked_segments AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY default_rate_pct DESC
        ) AS risk_rank
    FROM segment_analysis)
SELECT
    Loan_intent,
    Loan_grade,
    total_loans,
    defaulted_loans,
    default_rate_pct,
    total_exposure,
    defaulted_exposure,
    risk_rank
FROM ranked_segments
WHERE risk_rank <= 10
ORDER BY risk_rank, defaulted_exposure DESC;


WITH segment_summary AS (
SELECT
Loan_intent,
COUNT(*) AS total_loans,
SUM(Loan_amnt) AS total_exposure,
SUM(Loan_status) AS defaulted_loans,
100.0 * SUM(Loan_status) / COUNT(*)AS default_rate_pct
FROM credit_risk
GROUP BY Loan_intent)
SELECT
Loan_intent,
total_loans,
defaulted_loans,
ROUND(default_rate_pct, 2)AS default_rate_pct,
total_exposure,
ROUND(100.0 * total_exposure /SUM(total_exposure) OVER (),2) AS portfolio_exposure_pct
FROM segment_summary
ORDER BY default_rate_pct DESC;




