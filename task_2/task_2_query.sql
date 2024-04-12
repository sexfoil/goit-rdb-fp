CREATE TABLE IF NOT EXISTS country_entity (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	name VARCHAR(64) NOT NULL,
    code VARCHAR(64) NOT NULL
);

INSERT INTO country_entity (name, code)
SELECT Entity, Code 
FROM infectious_cases 
GROUP BY Entity, Code;

ALTER TABLE infectious_cases 
ADD COLUMN country_entity_id INT NOT NULL DEFAULT 0;

SET SQL_SAFE_UPDATES = 0;
UPDATE infectious_cases AS ic
	INNER JOIN country_entity AS ce ON ic.Code = ce.code
SET ic.country_entity_id = ce.id;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE infectious_cases
	DROP COLUMN Entity,
  DROP COLUMN Code;
  
ALTER TABLE infectious_cases
ADD CONSTRAINT fk_country_entity_id FOREIGN KEY (country_entity_id) REFERENCES country_entity(id);
