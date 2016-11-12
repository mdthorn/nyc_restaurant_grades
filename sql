DROP TABLE restaurant_grades;
CREATE TABLE restaurant_grades (
        id      int,
        borough varchar(200),
        zip     varchar(5),
        cuisine varchar(200),
        inspection_date date,
        score   int,
        grade   varchar(200)
        );
        
COPY restaurant_grades (
        id,
        borough,
        zip,
        cuisine,
        inspection_date,
        score,
        grade
        )
FROM '/Users/mthorn/Documents/fun/grades.csv'
WITH DELIMITER ',' CSV;

-- look at thresholds for scores

SELECT grade,
        COUNT(*) as total,
        MIN(score) as min_score,
        AVG(score) as avg_score,
        MAX(score) as max_score
FROM restaurant_grades
WHERE score IS NOT NULL
        AND grade IS NOT NULL
GROUP BY 1
ORDER BY 4

-- avg. score across city

WITH scores as (
        SELECT DISTINCT r1.id,
                score,
                zip,
                grade
        FROM restaurant_grades r1
        JOIN (
                SELECT id,
                        MAX(inspection_date) as last_inspection
                FROM restaurant_grades
                WHERE score >= 0
                        AND grade IN ('A', 'B', 'C')
                GROUP BY 1
                ) r2
                ON r1.id = r2.id AND r1.inspection_date = r2.last_inspection
        WHERE r1.score >= 0
                AND r1.grade IN ('A', 'B', 'C')
        )
SELECT grade,
        COUNT(id) as restaurants
FROM scores
GROUP BY 1
ORDER BY 1

-- grades by borough

WITH scores as (
        SELECT DISTINCT r1.id,
                score,
                borough,
                grade
        FROM restaurant_grades r1
        JOIN (
                SELECT id,
                        MAX(inspection_date) as last_inspection
                FROM restaurant_grades
                WHERE score >= 0
                        AND grade IN ('A', 'B', 'C')
                GROUP BY 1
                ) r2
                ON r1.id = r2.id AND r1.inspection_date = r2.last_inspection
        WHERE r1.score >= 0
                AND r1.grade IN ('A', 'B', 'C')
        )
SELECT borough,
        grade,
        COUNT(id) as restaurants
FROM scores
GROUP BY 1,2
ORDER BY 1,2

-- by neighborhood

WITH scores as (
        SELECT DISTINCT r1.id,
                score,
                zip,
                grade,
                borough
        FROM restaurant_grades r1
        JOIN (
                SELECT id,
                        MAX(inspection_date) as last_inspection
                FROM restaurant_grades
                WHERE score >= 0
                        AND grade IN ('A', 'B', 'C')
                GROUP BY 1
                ) r2
                ON r1.id = r2.id AND r1.inspection_date = r2.last_inspection
        WHERE r1.score >= 0
                AND r1.grade IN ('A', 'B', 'C')
        )
SELECT borough,
        CASE WHEN zip::int IN (10453, 10457, 10460) THEN 'Central Bronx'
        WHEN zip::int IN (10458, 10467, 10468) THEN 'Bronx Park and Fordham'
        WHEN zip::int IN (10451, 10452, 10456) THEN 'High Bridge and Morrisania'
        WHEN zip::int IN (10454, 10455, 10459, 10474) THEN 'Hunts Point and Mott Haven'
        WHEN zip::int IN (10463, 10471) THEN 'Kingsbridge and Riverdale'
        WHEN zip::int IN (10466, 10469, 10470, 10475) THEN 'Northeast Bronx'
        WHEN zip::int IN (10461, 10462,10464, 10465, 10472, 10473) THEN 'Southeast Bronx'
        WHEN zip::int IN (11212, 11213, 11216, 11233, 11238) THEN 'Central Brooklyn'
        WHEN zip::int IN (11209, 11214, 11228) THEN 'Southwest Brooklyn'
        WHEN zip::int IN (11204, 11218, 11219, 11230) THEN 'Borough Park'
        WHEN zip::int IN (11234, 11236, 11239) THEN 'Canarsie and Flatlands'
        WHEN zip::int IN (11223, 11224, 11229, 11235) THEN 'Southern Brooklyn'
        WHEN zip::int IN (11201, 11205, 11215, 11217, 11231) THEN 'Northwest Brooklyn'
        WHEN zip::int IN (11203, 11210, 11225, 11226) THEN 'Flatbush'
        WHEN zip::int IN (11207, 11208) THEN 'East New York and New Lots'
        WHEN zip::int IN (11211, 11222) THEN 'Greenpoint'
        WHEN zip::int IN (11220, 11232) THEN 'Sunset Park'
        WHEN zip::int IN (11206, 11221, 11237) THEN 'Bushwick and Williamsburg'
        WHEN zip::int IN (10026, 10027, 10030, 10037, 10039) THEN 'Central Harlem'
        WHEN zip::int IN (10001, 10011, 10018, 10019, 10020, 10036) THEN 'Chelsea and Clinton'
        WHEN zip::int IN (10029, 10035) THEN 'East Harlem'
        WHEN zip::int IN (10010, 10016, 10017, 10022) THEN 'Gramercy Park and Murray Hill'
        WHEN zip::int IN (10012, 10013, 10014) THEN 'Greenwich Village and Soho'
        WHEN zip::int IN (10004, 10005, 10006, 10007, 10038, 10280) THEN 'Lower Manhattan'
        WHEN zip::int IN (10002, 10003, 10009) THEN 'Lower East Side'
        WHEN zip::int IN (10021, 10028, 10044, 10065, 10075, 10128) THEN 'Upper East Side'
        WHEN zip::int IN (10023, 10024, 10025) THEN 'Upper West Side'
        WHEN zip::int IN (10031, 10032, 10033, 10034, 10040) THEN 'Inwood and Washington Heights'
        WHEN zip::int IN (11361, 11362, 11363, 11364) THEN 'Northeast Queens'
        WHEN zip::int IN (11354, 11355, 11356, 11357, 11358, 11359, 11360) THEN 'North Queens'
        WHEN zip::int IN (11365, 11366, 11367) THEN 'Central Queens'
        WHEN zip::int IN (11412, 11423, 11432, 11433, 11434, 11435, 11436) THEN 'Jamaica'
        WHEN zip::int IN (11101, 11102, 11103, 11104, 11105, 11106) THEN 'Northwest Queens'
        WHEN zip::int IN (11374, 11375, 11379, 11385) THEN 'West Central Queens'
        WHEN zip::int IN (11691, 11692, 11693, 11694, 11695, 11697) THEN 'Rockaways'
        WHEN zip::int IN (11004, 11005, 11411, 11413, 11422, 11426, 11427, 11428, 11429) THEN 'Southeast Queens'
        WHEN zip::int IN (11414, 11415, 11416, 11417, 11418, 11419, 11420, 11421) THEN 'Southwest Queens'
        WHEN zip::int IN (11368, 11369, 11370, 11372, 11373, 11377, 11378) THEN 'West Queens'
        WHEN zip::int IN (10302, 10303, 10310) THEN 'Port Richmond'
        WHEN zip::int IN (10306, 10307, 10308, 10309, 10312) THEN 'South Shore'
        WHEN zip::int IN (10301, 10304, 10305) THEN 'Stapleton and St. George'
        WHEN zip::int IN (10314) THEN 'Mid-Island'
        ELSE 'Other' END as neighborhood,
        COUNT(id) as restaurants,
        COUNT(CASE WHEN grade = 'A' THEN id END) as graded_a
FROM scores
GROUP BY 1,2
ORDER BY 3 DESC

-- avg. score by zip

WITH scores as (
        SELECT DISTINCT r1.id,
                score,
                zip
        FROM restaurant_grades r1
        JOIN (
                SELECT id,
                        MAX(inspection_date) as last_inspection
                FROM restaurant_grades
                WHERE score IS NOT NULL
                GROUP BY 1
                ) r2
                ON r1.id = r2.id AND r1.inspection_date = r2.last_inspection
        WHERE r1.score IS NOT NULL
        )
SELECT zip,
        COUNT(DISTINCT id) as restaurants_inspected,
        AVG(score) as avg_score
FROM scores
GROUP BY 1
ORDER BY 2 DESC

-- % with A,B,C by zip

WITH grades as (
        SELECT DISTINCT r1.id,
                zip,
                grade
        FROM restaurant_grades r1
        JOIN (
                SELECT id,
                        MAX(inspection_date) as last_inspection
                FROM restaurant_grades
                WHERE grade IN ('A', 'B', 'C')
                GROUP BY 1
                ) r2
                ON r1.id = r2.id AND r1.inspection_date = r2.last_inspection
        WHERE r1.grade IN ('A', 'B', 'C')
        )
SELECT zip,
        COUNT(DISTINCT id) as restaurants_inspected,
        COUNT(DISTINCT CASE WHEN grade = 'A' THEN id END) as a,
        COUNT(DISTINCT CASE WHEN grade = 'B' THEN id END) as b,
        COUNT(DISTINCT CASE WHEN grade = 'C' THEN id END) as c
FROM grades
GROUP BY 1
ORDER BY 2 DESC

-- by cuisine

WITH grades as (
        SELECT DISTINCT r1.id,
                cuisine,
                grade,
                score
        FROM restaurant_grades r1
        JOIN (
                SELECT id,
                        MAX(inspection_date) as last_inspection
                FROM restaurant_grades
                WHERE grade IN ('A', 'B', 'C')
                        AND score >= 0
                GROUP BY 1
                ) r2
                ON r1.id = r2.id AND r1.inspection_date = r2.last_inspection
        WHERE r1.grade IN ('A', 'B', 'C')
                AND r1.score >= 0
        )
SELECT cuisine,
        COUNT(DISTINCT id) as restaurants_inspected,
        AVG(score) as avg_score,
        COUNT(DISTINCT CASE WHEN grade = 'A' THEN id END) as a,
        COUNT(DISTINCT CASE WHEN grade = 'B' THEN id END) as b,
        COUNT(DISTINCT CASE WHEN grade = 'C' THEN id END) as c
FROM grades
GROUP BY 1
ORDER BY 2 DESC

-- results over time

SELECT month,
        COUNT(id) as inspections,
        AVG(score) as avg_score,
        COUNT(CASE WHEN grade = 'A' THEN id END) as a,
        COUNT(CASE WHEN grade = 'B' THEN id END) as b,
        COUNT(CASE WHEN grade = 'C' THEN id END) as c
FROM (
        SELECT DISTINCT date_trunc('month', inspection_date)::date as month,
                id,
                score,
                grade
        FROM restaurant_grades
        WHERE grade IN ('A', 'B', 'C')
                AND score >= 0
                AND inspection_date >= '2013-01-01'
        ) g
GROUP BY 1
ORDER BY 1

-- by month for seasonality

SELECT date_part('month', month) as month,
        COUNT(id) as inspections,
        AVG(score) as avg_score,
        COUNT(CASE WHEN grade = 'A' THEN id END) as a,
        COUNT(CASE WHEN grade = 'B' THEN id END) as b,
        COUNT(CASE WHEN grade = 'C' THEN id END) as c
FROM (
        SELECT DISTINCT date_trunc('month', inspection_date)::date as month,
                id,
                score,
                grade
        FROM restaurant_grades
        WHERE grade IN ('A', 'B', 'C')
                AND score >= 0
                AND inspection_date >= '2013-01-01'
        ) g
GROUP BY 1
ORDER BY 1

-- do B and C restaurants improve in their next inspection? do A restaurants backslide? 

WITH inspections as (
        SELECT *,
                LAG(score) OVER (PARTITION BY id ORDER BY inspection_date ASC) as prev_score,
                LAG(grade) OVER (PARTITION BY id ORDER BY inspection_date ASC) as prev_grade,
                LEAD(score) OVER (PARTITION BY id ORDER BY inspection_date ASC) as next_score,
                LEAD(grade) OVER (PARTITION BY id ORDER BY inspection_date ASC) as next_grade
        FROM (
                SELECT DISTINCT id,
                        inspection_date,
                        score,
                        grade
                FROM restaurant_grades
                WHERE grade IN ('A', 'B', 'C')
                        AND score >= 0
                ) i
        )
SELECT grade,
        COUNT(*) as inspections,
        AVG(next_score - score) as avg_next_score_change,
        COUNT(CASE WHEN next_grade = 'A' THEN id END) as next_grade_a
FROM inspections
WHERE next_score IS NOT NULL
        AND next_grade IS NOT NULL
GROUP BY 1
ORDER BY 1
