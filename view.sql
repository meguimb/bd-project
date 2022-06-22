CREATE VIEW Vendas(ean, cat, ano, trimestre, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT produto.ean, categoria.nome, EXTRACT(QUARTER FROM     “timestamps”), EXTRACT(DAY FROM “timestamps”), EXTRACT(DOW FROM “timestamps”), pr.distrito, pr.concelho, er.unidades
FROM produto
INNER JOIN categoria ON (produto.cat = categoria.nome)
INNER JOIN evento_reposicao AS er ON (produto.ean = er.ean)
INNER JOIN instalada_em AS i ON (er.fabricante = i.fabricante)
INNER JOIN ponto_de_retalho AS pr ON (i.local = pr.nome);
