SELECT id INTO TEMP TABLE nameorphans
FROM name
WHERE NOT EXISTS (
    SELECT 1
    FROM feature 
    WHERE feature.id = name.id
);

DELETE FROM name
WHERE id IN (
      SELECT id
      FROM nameorphans
);
