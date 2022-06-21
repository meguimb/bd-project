/*
(RI-1) Uma Categoria não pode estar contida em si própria 
RI-1:
	Evento: sempre que se adiciona uma relação tem_outra
	Condição: a super categoria é igual à categoria?
	Ação: não adicionar esta relação à tabela
*/
CREATE OR REPLACE FUNCTION check_cat_contains_itself_proc()	 
RETURNS TRIGGER AS 
$$ 
BEGIN			 		
    IF NEW.super_categoria=NEW.categoria THEN			 				
        RAISE EXCEPTION 'Uma Categoria não pode estar contida em si própria.';
    END IF;	 		

    RETURN NEW;
END;    
$$ LANGUAGE plpgsql; 

CREATE TRIGGER check_cat_contains_itself_trigger
BEFORE UPDATE OR INSERT ON tem_outra
FOR EACH ROW EXECUTE PROCEDURE check_cat_contains_itself_proc();


/*
(RI-4) O número de unidades repostas num Evento de Reposição não pode exceder o número de unidades especificado no Planograma 
RI-4:
	Evento: sempre que há um evento de reposição
	Condição: se numero de unidades a adicionar for maior do que as no planograma
Ação: nao fazer evento de reposição
*/
CREATE OR REPLACE FUNCTION check_num_unidades_repostas_proc()	 
RETURNS TRIGGER AS 
$$ 
DECLARE unidades_max INTEGER;
BEGIN	
    SELECT unidades FROM planograma INTO unidades_max
    WHERE ean=NEW.ean AND nro=NEW.nro AND num_serie=NEW.num_serie AND fabricante=NEW.fabricante;

    IF NEW.unidades > unidades_max THEN			 				
        RAISE EXCEPTION 'O número de unidades repostas num Evento de Reposição não pode exceder o número de unidades especificado no Planograma.';
    END IF;	 		

    RETURN NEW;
END;    
$$ LANGUAGE plpgsql; 

CREATE TRIGGER check_num_unidades_repostas_trigger
BEFORE UPDATE OR INSERT ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE check_num_unidades_repostas_proc();


/*
(RI-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das Categorias desse produto
RI-5:
	Evento: sempre que há um evento de reposição
	Condição: verificar a tabela tem_categoria e se 
Ação: nao fazer evento de reposição
*/
CREATE OR REPLACE FUNCTION check_cat_produto_reposto_proc()	 
RETURNS TRIGGER AS 
$$ 
DECLARE prod_categoria VARCHAR(255);
DECLARE possiveis_categorias VARCHAR(255)[];
BEGIN	
    SELECT nome FROM prateleira WHERE nro=NEW.nro AND num_serie=NEW.num_serie AND fabricante=NEW.fabricante;

    IF prod_categoria NOT IN (SELECT nome FROM tem_categoria WHERE ean=NEW.ean) THEN			 				
        RAISE EXCEPTION 'Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das Categorias desse produto'; 
    END IF;	 		

    RETURN NEW;
END;    
$$ LANGUAGE plpgsql; 

CREATE TRIGGER check_cat_produto_reposto_trigger
BEFORE UPDATE OR INSERT ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE check_cat_produto_reposto_proc();