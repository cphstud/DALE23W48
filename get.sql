CREATE OR REPLACE view getlatest as
SELECT c.mpg,c.milage,c.maketype,c.region,c.year,c.type,c.make,c.car_id,ph.price, ph.scrapedate, ph.sold
FROM cars c
INNER JOIN (
    SELECT car_id, MAX(scrapedate) AS max_date
    FROM pricehistory
    GROUP BY car_id
) latest_ph ON c.car_id = latest_ph.car_id
INNER JOIN pricehistory ph ON latest_ph.car_id = ph.car_id AND latest_ph.max_date = ph.scrapedate
WHERE ph.sold=0
