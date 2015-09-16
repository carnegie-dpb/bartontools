SELECT id INTO TEMP TABLE attributeorphans
FROM attribute
WHERE NOT EXISTS (
    SELECT 1
    FROM feature 
    WHERE feature.id = attribute.id
);

DELETE FROM attribute
WHERE id IN (
      SELECT id
      FROM attributeorphans
);
