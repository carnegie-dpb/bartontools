-- display the top 1000 repeating TR contigs (independent of source

SELECT count(*),tag,name 
       FROM typelist,feature,name 
       WHERE tag LIKE 'contig:%' 
       AND typelist.id=feature.typeid 
       AND feature.id=name.id 
GROUP BY tag,name 
ORDER BY count DESC 
LIMIT 1000;
