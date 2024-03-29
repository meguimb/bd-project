/*Número total de artigos vendidos num dado período (i.e. entre duas datas), 
por dia da semana, por concelho e no total*/

SELECT dia_semana, concelho, SUM(unidades)
FROM Vendas
WHERE ano > 2020 AND ano < 2022
GROUP BY ROLLUP(dia_semana, concelho)
ORDER BY dia_semana, concelho; 

/*Número total de artigos vendidos num dado distrito (i.e. “Lisboa”), 
por concelho, categoria, dia da semana e no total*/

SELECT concelho, cat, dia_semana, SUM(unidades)
FROM Vendas
WHERE distrito = 'Lisboa'
GROUP BY ROLLUP(concelho, cat, dia_semana)
ORDER BY concelho, cat, dia_semana;
