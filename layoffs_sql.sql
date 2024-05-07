select * from layoffs
-- remove duplicates
-- standardize data
-- null or blank values 
-- remove columns;

SELECT COUNT(`DATE`)
FROM layoffs_staging2
group by 'date';

-- create another table as lays_off from layoffs
create table layoffs_staging like layoffs;
select * from layoffs_staging;
insert layoffs_staging 
select  * from layoffs;
select * ,
row_number() over( partition by company,industry,total_laid_off, percentage_laid_off,`date`)as row_num
from layoffs_staging;

 --  view a table  which is not created 
with duplicate_cte as 
(
select * ,
row_number() over( partition by company,industry,total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions)as row_num
from layoffs_staging
)
select * from duplicate_cte
where row_num > 1;


-- we have create another table from layoffs_staging than name as layoffs_staging2 
-- we have insert same value from layoffs_staging and than we add 1 row_num column than we delete 
-- which is greater than 2.  

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
select * from layoffs_staging2;
INSERT INTO layoffs_staging2
select * ,
row_number() over( partition by company,industry,total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions)as row_num
from layoffs_staging;





DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- standardizing data
select company ,trim(company)
from  layoffs_staging2;

update layoffs_staging2
set company = trim(company);
                                   ---   we convert croptocurrency or crypto to crypto
select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry like 'Crypto%';
-- we standardize some error
select * from layoffs_staging2;
select distinct country, trim(country)
from layoffs_staging2
where country like 'united states%'
order by 1;


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
where country like 'united states%'
;
          --  convert date datatype to date 
select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y' )

select `date` from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;


 --- find the null values and blank values 
 
 select * from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;

update layoffs_staging2 t1
join layoffs_staging2 t2 on t1.company = t2.company 
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry = '';

select industry from layoffs_staging2
where industry is null ;

select * from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
    -- remove columns and row (row_num) which is not required
  delete 
  from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 alter table layoffs_staging2
 drop row_num ;
 
                      --- # Exploratory Data Anaysis 
select * 
from layoffs_staging2;

select max(total_laid_off)
from layoffs_staging2;
 
 select min(`date`), max(`date`)
 from layoffs_staging2;
 
 select company,industry,country, sum(total_laid_off) as laid_off
 from layoffs_staging2
 group by company,country,industry
 order by country desc;
 
-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;
-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_staging2
WHERE  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went loss.

 SOMEWHAT TOUGHER AND MOSTLY USING GROUP BY--
 
 ------------------------------------------------------------------------------------------------
---Using group by
-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY 2 DESC
LIMIT 5;
-- now that's just on a single day


-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- this it total in the past 3 years or in the dataset

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- this it total in the past 3 years or in the dataset

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 deSC
limit 3;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage,location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage,location
ORDER BY 2 DESC
limit 10;







 
 
 
 





