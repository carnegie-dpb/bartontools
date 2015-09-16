-- count the occurrence of TE types

-- SELECT substring(name from '(.*_.*)_') AS tegroup, count(*)
SELECT substring(name from '(.*)_.*_') AS tegroup, count(*)
       FROM typelist,feature,name 
       WHERE tag='transposon:MaizeTEDB' 
       AND typelist.id=feature.typeid 
       AND feature.id=name.id 
GROUP BY tegroup
ORDER BY count DESC;

