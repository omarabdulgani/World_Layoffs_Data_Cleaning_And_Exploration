-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Date Range
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT * 
FROM layoffs_staging2;

-- YEAR FUNCTION
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
--
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(percentage_laid_off) -- doesnt work 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- ROLLING SUM

SELECT 
	SUBSTRING(`date`,1,7) AS `month`,
    SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1;

WITH rolling_total AS (
	SELECT 
		SUBSTRING(`date`,1,7) AS `month`,
		SUM(total_laid_off) AS total_off
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `month`
	ORDER BY 1
)

SELECT 
	`month`, total_off,
    SUM(total_off) OVER(ORDER BY `month`) as rolling_sum
FROM rolling_total;

--

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT 
	company, 
    YEAR(`date`),
    SUM(total_laid_off) as sum_of_total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year (company, years, total_laid_offs) AS (
	SELECT 
		company, 
		YEAR(`date`),
		SUM(total_laid_off) as sum_of_total_laid_off
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_offs DESC) as `rank`
FROM company_year
WHERE years IS NOT NULL
ORDER BY `rank` ASC;

-- now we use the query above as another CTE to find the ranking of top 5 most layoffs by company

WITH company_year (company, years, total_laid_offs) AS (
	SELECT 
		company, 
		YEAR(`date`),
		SUM(total_laid_off) as sum_of_total_laid_off
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
),
company_year_rank as(
	SELECT 
		*, 
        DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_offs DESC) as `rank`
	FROM company_year
	WHERE years IS NOT NULL
)
SELECT * 
FROM company_year_rank
WHERE `rank` <= 5 ; 
































