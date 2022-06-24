drop table categoria CASCADE;
drop table categoria_simples CASCADE;
drop table super_categoria CASCADE;
drop table tem_outra CASCADE;
drop table produto CASCADE;
drop table tem_categoria CASCADE;
drop table IVM CASCADE;
drop table ponto_de_retalho CASCADE;
drop table instalada_em CASCADE;
drop table prateleira CASCADE;
drop table planograma CASCADE;
drop table retalhista CASCADE;
drop table responsavel_por CASCADE;
drop table evento_reposicao CASCADE;

----------------------------------------
-- Table Creation
----------------------------------------

CREATE DATABASE my_database;

CREATE TABLE categoria (
	nome VARCHAR(255) UNIQUE NOT NULL,
	PRIMARY KEY (nome)
);

CREATE TABLE categoria_simples (
    nome VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (nome) REFERENCES categoria(nome)
);

CREATE TABLE super_categoria (
    nome VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (nome) REFERENCES categoria(nome)
);

CREATE TABLE tem_outra (
	super_categoria VARCHAR(255) NOT NULL,
	categoria VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (super_categoria) REFERENCES super_categoria(nome),
    FOREIGN KEY (categoria) REFERENCES categoria(nome)	
);

CREATE TABLE produto (
    ean VARCHAR(13) UNIQUE NOT NULL,
    cat VARCHAR(255) NOT NULL,
    descr VARCHAR(255) NOT NULL,
    PRIMARY KEY (ean),
    FOREIGN KEY (cat) REFERENCES categoria(nome)
);

CREATE TABLE tem_categoria (
    ean VARCHAR(13) UNIQUE NOT NULL,
    categoria VARCHAR(255) NOT NULL
);

CREATE TABLE IVM (
	num_serie INT UNIQUE NOT NULL,
	fabricante VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY (num_serie, fabricante)
);

CREATE TABLE ponto_de_retalho (
	nome VARCHAR(255) UNIQUE NOT NULL,
	distrito VARCHAR(255) NOT NULL,
	concelho VARCHAR(255) NOT NULL,
	PRIMARY KEY (nome)
);

CREATE TABLE instalada_em (
	num_serie INT UNIQUE NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	local VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
    FOREIGN KEY (local) REFERENCES ponto_de_retalho(nome)	
);

CREATE TABLE prateleira (
	nro INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
    altura NUMERIC(6, 2) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
    FOREIGN KEY (nome) REFERENCES categoria(nome),
    PRIMARY KEY (nro, num_serie, fabricante)
);

CREATE TABLE planograma (
	ean VARCHAR(13) NOT NULL,
	nro INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	faces INT NOT NULL,
	unidades INT NOT NULL,
    loc VARCHAR(255) NOT NULL,
    FOREIGN KEY (ean) REFERENCES produto(ean),
    FOREIGN KEY (nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante),
    PRIMARY KEY (ean, nro, num_serie, fabricante)
);


-- NOTA: TIN, que tipo de dados é? o TIN depende do país
CREATE TABLE retalhista (
	tin VARCHAR(50) UNIQUE NOT NULL,
	nome VARCHAR(255) UNIQUE NOT NULL,
	PRIMARY KEY (tin)
);

CREATE TABLE responsavel_por (
	nome_cat VARCHAR(255) NOT NULL,
	tin VARCHAR(50) NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	FOREIGN KEY (nome_cat) REFERENCES categoria(nome),
	FOREIGN KEY (tin) REFERENCES retalhista(tin),
	FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante)
);

CREATE TABLE evento_reposicao (
	ean VARCHAR(13) NOT NULL,
	nro INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	instante TIMESTAMP NOT NULL,
	unidades INT NOT NULL,
	tin VARCHAR(50) NOT NULL,
	FOREIGN KEY (ean, nro, num_serie, fabricante) REFERENCES planograma (ean, nro, num_serie, fabricante),
	FOREIGN KEY (tin) REFERENCES retalhista(tin),
	PRIMARY KEY (ean, nro, num_serie, fabricante, instante)
);

----------------------------------------
-- Populate Relations 
----------------------------------------

insert into categoria values ('Bebidas');
insert into categoria values ('Bebidas Frias');
insert into categoria values ('Bebidas Quentes');
insert into categoria values ('Bolachas');
insert into categoria values ('Cereais');

insert into categoria_simples values ('Bebidas Frias');
insert into categoria_simples values ('Bebidas Quentes');
insert into categoria_simples values ('Bolachas');
insert into categoria_simples values ('Cereais');

insert into super_categoria values ('Bebidas');

insert into tem_outra values ('Bebidas', 'Bebidas Frias');
insert into tem_outra values ('Bebidas', 'Bebidas Quentes');

insert into produto values ('1', 'Bebidas Frias', 'Monster');
insert into produto values ('2', 'Bebidas Frias', 'Fanta');
insert into produto values ('3', 'Bebidas Quentes', 'Café');
insert into produto values ('4', 'Bebidas Quentes', 'Chocolate Quente');
insert into produto values ('5', 'Bolachas', 'Maria');
insert into produto values ('6', 'Bolachas', 'Bolachas Recheadas Cacau');
insert into produto values ('7', 'Bolachas', 'Belgas');
insert into produto values ('8', 'Bolachas', 'Argolas');
insert into produto values ('9', 'Cereais', 'Chocapic');
insert into produto values ('10', 'Cereais', 'Estrelitas');
insert into produto values ('11', 'Cereais', 'Nesquik');

insert into tem_categoria values ('1', 'Bebidas Frias');
insert into tem_categoria values ('2', 'Bebidas Frias');
insert into tem_categoria values ('3', 'Bebidas Quentes');
insert into tem_categoria values ('4', 'Bebidas Quentes');
insert into tem_categoria values ('5', 'Bolachas');
insert into tem_categoria values ('6', 'Bolachas');
insert into tem_categoria values ('7', 'Bolachas');
insert into tem_categoria values ('8', 'Bolachas');
insert into tem_categoria values ('9', 'Cereais');
insert into tem_categoria values ('10', 'Cereais');
insert into tem_categoria values ('11', 'Cereais');

insert into IVM values (1, 'Margarida');
insert into IVM values (2, 'Gonçalo');
insert into IVM values (3, 'Nolten');
insert into IVM values (4, 'Laura');

insert into ponto_de_retalho values ('IST', 'Lisboa', 'Lisboa');
insert into ponto_de_retalho values ('ESSMO', 'Santarém', 'Tomar');
insert into ponto_de_retalho values ('JÁCOME', 'Santarém', 'Tomar');
insert into ponto_de_retalho values ('SAC', 'Lisboa', 'Loures');

insert into instalada_em values (1, 'Margarida', 'IST');
insert into instalada_em values (2, 'Gonçalo', 'ESSMO');
insert into instalada_em values (3, 'Nolten', 'JÁCOME');
insert into instalada_em values (4, 'Laura', 'SAC');

insert into prateleira values (01, 1, 'Margarida', 10.5, 'Bebidas');
insert into prateleira values (02, 1, 'Margarida', 10.5, 'Bolachas');
insert into prateleira values (03, 1, 'Margarida', 10.5, 'Cereais');

insert into prateleira values (01, 2, 'Gonçalo', 11.25, 'Bebidas Frias');
insert into prateleira values (02, 2, 'Gonçalo', 11.25, 'Bebidas Quentes');
insert into prateleira values (03, 2, 'Gonçalo', 11.25, 'Cereais');
insert into prateleira values (04, 2, 'Gonçalo', 11.25, 'Bolachas');
insert into prateleira values (05, 2, 'Gonçalo', 11.25, 'Bolachas');

insert into prateleira values (01, 3, 'Nolten', 9.25, 'Bebidas');
insert into prateleira values (02, 3, 'Nolten', 9.25, 'Cereais');

insert into prateleira values (01, 4, 'Laura', 10, 'Cereais');
insert into prateleira values (02, 4, 'Laura', 10, 'Bebidas');
insert into prateleira values (03, 4, 'Laura', 10, 'Bebidas Frias');
insert into prateleira values (04, 4, 'Laura', 10, 'Bebidas Quentes');
insert into prateleira values (05, 4, 'Laura', 10, 'Bolachas');

insert into planograma values ('3', 01, 1, 'Margarida', 6, 12, 'IST');
insert into planograma values ('8', 02, 1, 'Margarida', 3, 7, 'IST');
insert into planograma values ('9', 03, 1, 'Margarida', 4, 7, 'IST');

insert into planograma values ('1', 01, 2, 'Gonçalo', 7, 20, 'ESSMO');
insert into planograma values ('4', 02, 2, 'Gonçalo', 8, 20, 'ESSMO');
insert into planograma values ('11', 03, 2, 'Gonçalo', 5, 10, 'ESSMO');
insert into planograma values ('5', 04, 2, 'Gonçalo', 4, 16, 'ESSMO');
insert into planograma values ('6', 05, 2, 'Gonçalo', 4, 16, 'ESSMO');

insert into planograma values ('2', 01, 3, 'Nolten', 4, 16, 'JÁCOME');
insert into planograma values ('10', 02, 3, 'Nolten', 4, 16, 'JÁCOME');

insert into planograma values ('9', 01, 4, 'Laura', 2, 10, 'SAC');
insert into planograma values ('1', 02, 4, 'Laura', 2, 10, 'SAC');
insert into planograma values ('2', 03, 4, 'Laura', 2, 10, 'SAC');
insert into planograma values ('3', 04, 4, 'Laura', 2, 10, 'SAC');
insert into planograma values ('7', 05, 4, 'Laura', 2, 10, 'SAC');

insert into retalhista values ('nest', 'Nestlé');
insert into retalhista values ('neg', 'Negócio Local');
insert into retalhista values ('com', 'Comerciante Bebidas');

insert into responsavel_por values ('Bebidas', 'com', 1, 'Margarida');
insert into responsavel_por values ('Bolachas', 'nest', 1, 'Margarida');
insert into responsavel_por values ('Cereais', 'nest', 1, 'Margarida');

insert into responsavel_por values ('Bebidas Frias', 'neg', 2, 'Gonçalo');
insert into responsavel_por values ('Bebidas Quentes', 'neg', 2, 'Gonçalo');
insert into responsavel_por values ('Cereais', 'nest', 2, 'Gonçalo');
insert into responsavel_por values ('Bolachas', 'nest', 2, 'Gonçalo');

insert into responsavel_por values ('Bebidas', 'com', 3, 'Nolten');
insert into responsavel_por values ('Cereais', 'nest', 3, 'Nolten');

insert into responsavel_por values ('Bebidas', 'com', 4, 'Laura');
insert into responsavel_por values ('Bebidas Frias', 'neg', 4, 'Laura');
insert into responsavel_por values ('Bebidas Quentes', 'neg', 4, 'Laura');
insert into responsavel_por values ('Bolachas', 'nest', 4, 'Laura');
insert into responsavel_por values ('Cereais', 'nest', 4, 'Laura');

insert into evento_reposicao values ('3', 01, 1, 'Margarida', '05-08-2022T10:33:22', 5, 'com');
insert into evento_reposicao values ('8', 02, 1, 'Margarida', '20-01-2022T16:40:22', 3, 'nest');
