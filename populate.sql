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
	super_categoria VARCHAR(255) UNIQUE NOT NULL,
	categoria VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (super_categoria) REFERENCES super_categoria(nome),
    FOREIGN KEY (categoria) REFERENCES categoria(nome)	
);

CREATE TABLE produto (
    ean VARCHAR(13) UNIQUE NOT NULL,
    cat VARCHAR(255) UNIQUE NOT NULL,
    descr VARCHAR(255) NOT NULL,
    PRIMARY KEY (ean),
    FOREIGN KEY (cat) REFERENCES categoria(nome)
);

CREATE TABLE tem_categoria (
    ean VARCHAR(13) UNIQUE NOT NULL,
    categoria VARCHAR(255) UNIQUE NOT NULL
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
	num_serie INT UNIQUE NOT NULL,
	fabricante VARCHAR(255) UNIQUE NOT NULL,
    altura NUMERIC(6, 2) NOT NULL,
    nome VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
    FOREIGN KEY (nome) REFERENCES categoria(nome),
    PRIMARY KEY (nro, num_serie, fabricante)
);

CREATE TABLE planograma (
	ean VARCHAR(13) UNIQUE NOT NULL,
	nro INT NOT NULL,
	num_serie INT UNIQUE NOT NULL,
	fabricante VARCHAR(255) UNIQUE NOT NULL,
	faces INT NOT NULL,
	unidades INT NOT NULL,
    loc VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (ean) REFERENCES produto(ean),
    FOREIGN KEY (nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante),
    PRIMARY KEY (ean, nro, num_serie, fabricante)
);


-- NOTA: TIN, que tipo de dados é? o TIN depende do país
CREATE TABLE retalhista (
	tin VARCHAR(50) UNIQUE NOT NULL,
	name VARCHAR(255) UNIQUE NOT NULL,
	PRIMARY KEY (tin)
);

CREATE TABLE responsavel_por (
	nome_cat VARCHAR(255) UNIQUE NOT NULL,
	tin VARCHAR(50) UNIQUE NOT NULL,
	num_serie INT UNIQUE NOT NULL,
	fabricante VARCHAR(255) UNIQUE NOT NULL,
	FOREIGN KEY (nome_cat) REFERENCES categoria(nome),
	FOREIGN KEY (tin) REFERENCES retalhista(tin),
	FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante)
);

CREATE TABLE evento_reposicao (
	ean VARCHAR(13) UNIQUE NOT NULL,
	nro INT NOT NULL,
	num_serie INT UNIQUE NOT NULL,
	fabricante VARCHAR(255) UNIQUE NOT NULL,
	instante TIMESTAMP NOT NULL,
	unidades INT NOT NULL,
	tin VARCHAR(50) UNIQUE NOT NULL,
	FOREIGN KEY (ean, nro, num_serie, fabricante) REFERENCES planograma (ean, nro, num_serie, fabricante),
	FOREIGN KEY (tin) REFERENCES retalhista(tin),
	PRIMARY KEY (ean, nro, num_serie, fabricante, instante)
);

