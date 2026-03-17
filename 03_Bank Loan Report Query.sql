use [Bank Loan [DB]]]

select * from dbo.Bank_Loan_Data

/***** DASHBOARD 1 : SUMMARY *******/ 

/**************1st kpi************/

---Total loan Applications---

select count(id) as Total_loan_applications from Bank_Loan_Data

---------MTD loan Applications-------

select count(id) as MTD_Total_loan_applications from Bank_Loan_Data
where month(issue_date) = 12 And year(issue_date) = 2021


-----PMTD loan applications------
select count(id) as PMTD_Total_loan_applications from Bank_Loan_Data
where month(issue_date) = 11 And year(issue_date) = 2021


/*****Formula for MoM : (MTD-PMTD)/PMTD = MoM  *****/

/*********2nd kpi *********/

------Total Funded Amount---------

select sum(loan_amount) AS Total_funded_Amount from Bank_Loan_Data 

-------MTD Total Funded Amount----------

select sum(loan_amount) AS MTD_Total_funded_Amount from Bank_Loan_Data 
where Month(issue_date) = 12 AND Year (issue_date) = 2021

----------PMTD Total Funded  Amount--------------

select sum(loan_amount) AS PMTD_Total_funded_Amount from Bank_Loan_Data 
where Month(issue_date) = 11 AND Year (issue_date) = 2021

----MOM = (PMTD-MTD)/PMTD------

/*******3rd kpi **********/

-------------Total Amount Received-------

select sum(Total_payment) from Bank_Loan_Data

------MTD Total amount recieved-------

select sum(total_payment) AS MTD_Total_Amount_recieved from Bank_Loan_Data 
where Month(issue_date) = 12 AND Year (issue_date) = 2021

-------PMTD Total Amount Recieved---------

select sum(total_payment) AS PMTD_Total_Amount_recieved from Bank_Loan_Data 
where Month(issue_date) = 11 AND Year (issue_date) = 2021

----MOM = (PMTD-MTD)/PMTD------

/********4H KPI**********/ 

-------Average Interest Rate---------
SELECT Round(AVG (INT_RATE),4)*100 as Avg_int_rate from Bank_Loan_Data

------MTD Average Interest Rate-----
SELECT Round(AVG (INT_RATE),4)*100 as MTD_Avg_int_rate from Bank_Loan_Data
where Month(issue_date)=12 AND Year (Issue_date)=2021

------PMTD Average Interest Rate-----
SELECT Round(AVG (INT_RATE),4)*100 as PMTD_Avg_int_rate from Bank_Loan_Data
where Month(issue_date)=11 AND Year (Issue_date)=2021

/********* 5TH KPI********/

------Average DTI------
select Round(Avg(dti),4)*100 as AVG_DTI from Bank_Loan_Data

------MTD Average DTI------

select Round(Avg(dti),4)*100 as MTD_AVG_DTI from Bank_Loan_Data
where Month(issue_date)=12 AND YEAR(issue_date) =2021

--------PMTD Average DTI---------

select Round(Avg(dti),4)*100 as PMTD_AVG_DTI from Bank_Loan_Data
where Month(issue_date)=11 AND YEAR(issue_date) =2021

/******Good Loan VS Bad Loan KPIS*******/

------Good Loan Percentage----------
select 
(count(case when Loan_status = 'fully paid' OR  Loan_status = 'current' then id end)*100)
/
count(id) as Good_Loan_Percentage
from Bank_Loan_Data

-------Good Loan Application---------

select count(id) as Good_Loan_Applications from Bank_Loan_Data
where loan_status='fully paid' Or loan_status='current'

---------Good Loan Funded Amount------------------

select sum(loan_Amount) as Good_Loan_Funded_Amount from Bank_Loan_Data
where loan_status='fully paid' Or loan_status='current'

----------Good Loan Total Amount Received------

select sum(Total_payment) as Good_Loan_Total_Amount_Received from Bank_Loan_Data
where loan_status='fully paid' Or loan_status='current'

-----------Bad Loan Percentage-----------

select 
(count(case when Loan_status = 'charged off'  then id end)*100)
/
count(id) as Bad_Loan_Percentage
from Bank_Loan_Data

-------------Bad Loan Applications----------
select count(ID) as Bad_Loan_Applications from Bank_Loan_Data
where loan_status= 'charged off'

-------------Bad Loan Funded Amount-----------

select sum(loan_amount) as Bad_Loan_funded_Amount from Bank_Loan_Data
where loan_status= 'charged off'

--------------Bad Loan Total Received Amount----------------
select sum(total_payment) as Bad_Loan_Total_Received_Amount from Bank_Loan_Data
where loan_status= 'charged off'

-----------Loan Status------------

select 
     loan_status,
     count (id) AS Total_Loan_Applications,
     Sum(Total_payment) as Total_Amount_Received,
     Sum (loan_amount) as Total_Funded_Amount,
     Avg (int_rate * 100) AS Intrest_Rate,
     Avg(Dti*100) as DTI
     From
     bank_loan_data
     group by Loan_status


     select 
     loan_status,
     sum(Total_payment) As MTD_Total_Amount_Recieved ,
     SUM(Loan_Amount) AS MTD_Total_Funded_Amount
     from Bank_Loan_Data
     where month(issue_date)=12
     Group by loan_status



     
/************ DASHBOARD 2 : OVERVIEW ***************/

--------- Monthly trend by issue date----------
SELECT 
		MONTH(ISSUE_DATE) AS MONTH_NUMBER,
		DATENAME(MONTH,ISSUE_DATE) AS MONTH_NAME,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY MONTH(ISSUE_DATE),	DATENAME(MONTH,ISSUE_DATE)
		ORDER BY MONTH(ISSUE_DATE)

----------------***Regional analysis by state**** ------------------
SELECT 
		Address_state ,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY Address_state
		ORDER BY SUM(LOAN_AMOUNT) DESC
		---------------****-----------------
		SELECT 
		Address_state ,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY Address_state
		ORDER BY COUNT(ID) DESC

----------------*******Loan term Analysis****-----------------

SELECT 
		term ,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY term 
		ORDER BY term

-------******** Employ Length Analysis*****--------------

SELECT 
			Emp_length  ,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY Emp_length 
		ORDER BY  COUNT(ID) desc

-----------****Loan Purpose Breakdown*****----------------
SELECT 
			purpose  ,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY purpose 
		ORDER BY  COUNT(ID) desc

------------******** Home Ownership Analysis***-------------
SELECT 
			Home_ownership ,
		COUNT(ID) AS TOTAL_LOAN_APPLICATIONS ,
		SUM(LOAN_AMOUNT) AS TOTAL_FUNDED_AMOUNT,
		SUM(TOTAL_PAYMENT) AS TOTAL_RECEIVED_AMOUNT
		FROM Bank_Loan_Data
		GROUP BY Home_ownership 
		ORDER BY  COUNT(ID) desc

