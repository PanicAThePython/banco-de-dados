CREATE DATABASE base_hotelaria;

CREATE TABLE cargo(
	cd_cargo INTEGER,
	ds_cargo VARCHAR(50),
	PRIMARY KEY (cd_cargo)
);

INSERT INTO cargo (cd_cargo, ds_cargo)
VALUES (1, 'camareira');
INSERT INTO cargo (cd_cargo, ds_cargo)
VALUES (2, 'garçom');
INSERT INTO cargo (cd_cargo, ds_cargo)
VALUES (3, 'gerente');
INSERT INTO cargo (cd_cargo, ds_cargo)
VALUES (4, 'recepcionista');
INSERT INTO cargo (cd_cargo, ds_cargo)
VALUES (5, 'bellboy');

CREATE TABLE funcionario(
	cd_funcionario INTEGER,
	nm_funcionario VARCHAR(50),
	PRIMARY KEY (cd_funcionario),
	cd_cargo INTEGER REFERENCES cargo(cd_cargo)
);

INSERT INTO funcionario (cd_funcionario, nm_funcionario, cd_cargo)
VALUES (1, 'Robson', 3);
INSERT INTO funcionario (cd_funcionario, nm_funcionario, cd_cargo)
VALUES (2, 'Wesley', 2);
INSERT INTO funcionario (cd_funcionario, nm_funcionario, cd_cargo)
VALUES (3, 'Paulo', 4);
INSERT INTO funcionario (cd_funcionario, nm_funcionario, cd_cargo)
VALUES (4, 'Marina', 1);
INSERT INTO funcionario (cd_funcionario, nm_funcionario, cd_cargo)
VALUES (5, 'João', 5);

CREATE TABLE cliente(
	cd_cliente INT,
	nm_cliente VARCHAR(50),
	ds_email VARCHAR(50),
	nr_telefone VARCHAR(15),
	PRIMARY KEY (cd_cliente)
);
INSERT INTO cliente (cd_cliente, nm_cliente, ds_email, nr_telefone)
VALUES (1, 'Natália', 'nweise@furb.br', '47911111111');
INSERT INTO cliente (cd_cliente, nm_cliente, ds_email, nr_telefone)
VALUES (2, 'Kauanny', 'kau123@gmail.com', '47922222222');

CREATE TABLE categoria(
	cd_categoria INTEGER,
	ds_categoria VARCHAR(50),
	PRIMARY KEY (cd_categoria)
);

INSERT INTO categoria (cd_categoria, ds_categoria)
VALUES (1, 'suíte solteiro');
INSERT INTO categoria (cd_categoria, ds_categoria)
VALUES (2, 'suíte casal');
INSERT INTO categoria (cd_categoria, ds_categoria)
VALUES (3, 'suíte casal master');

CREATE TABLE quarto(
	nr_quarto INTEGER,
	ds_quarto VARCHAR(50),
	nr_ocupantes INTEGER,
	PRIMARY KEY (nr_quarto),
	cd_categoria INTEGER REFERENCES categoria(cd_categoria)
);

INSERT INTO quarto (nr_quarto, ds_quarto, nr_ocupantes, cd_categoria)
VALUES (12, 'Em frente ao mar', 2, 3);
INSERT INTO quarto (nr_quarto, ds_quarto, nr_ocupantes, cd_categoria)
VALUES (23, 'Em frente ao jardim', 2, 2);
INSERT INTO quarto (nr_quarto, ds_quarto, nr_ocupantes, cd_categoria)
VALUES (52, 'Em frente ao mar', 1, 1);

CREATE TABLE reserva(
	nr_reserva INT,
	dt_reserva DATE,
	dt_entrada DATE,
	qt_diarias INT,
	fl_situacao CHAR(1),
	cd_cliente INTEGER REFERENCES cliente(cd_cliente),
	nr_quarto INTEGER REFERENCES quarto(nr_quarto),
	cd_funcionario INTEGER REFERENCES funcionario(cd_funcionario)	
);

INSERT INTO reserva(nr_reserva, dt_reserva, dt_entrada, qt_diarias, fl_situacao, cd_cliente, nr_quarto, cd_funcionario)
VALUES (1, '2022-05-05', '2022-05-21', 5, 'A', 1, 52, 3);
INSERT INTO reserva(nr_reserva, dt_reserva, dt_entrada, qt_diarias, fl_situacao, cd_cliente, nr_quarto, cd_funcionario)
VALUES (1, '2022-05-05', '2022-05-12', 5, 'A', 3, 52, 3);

CREATE TABLE servico(
	cd_servico INTEGER,
	ds_servico VARCHAR(50),
	PRIMARY KEY (cd_servico)
);

INSERT INTO servico (cd_servico, ds_servico)
VALUES (1, 'Entrega de comida');
INSERT INTO servico (cd_servico, ds_servico)
VALUES (2, 'Lavanderia');
INSERT INTO servico (cd_servico, ds_servico)
VALUES (3, 'Carregar malas');
INSERT INTO servico (cd_servico, ds_servico)
VALUES (4, 'Faxina');

CREATE TABLE hospedagem(
	cd_hospedagem INT, 
	dt_entrada DATE,
	dt_saida DATE, 
	fl_situacao CHAR(1),
	PRIMARY KEY (cd_hospedagem),
	cd_cliente INT REFERENCES cliente(cd_cliente), 
	cd_funcionario INTEGER REFERENCES funcionario(cd_funcionario),
	nr_quarto INTEGER REFERENCES quarto(nr_quarto)
);

INSERT INTO hospedagem(cd_hospedagem, dt_entrada, dt_saida, fl_situacao, cd_cliente, cd_funcionario, nr_quarto)
VALUES (1, NULL, NULL, 'A', 1, 3, 52);
INSERT INTO hospedagem(cd_hospedagem, dt_entrada, dt_saida, fl_situacao, cd_cliente, cd_funcionario, nr_quarto)
VALUES (2, '2022-05-12', '2022-05-16', 'A', 1, 3, 52);

CREATE TABLE hospedagem_servico (
	cd_hospedagem INT REFERENCES hospedagem(cd_hospedagem),
	cd_servico INTEGER REFERENCES servico(cd_servico),
	nr_sequencia INT,
	dt_solicitacao DATE,
	PRIMARY KEY (cd_hospedagem,cd_servico,nr_sequencia)
);



CREATE role 'grupo_gerente';
CREATE USER 'gt_rob' IDENTIFIED BY 'g3r3nt3';
GRANT SELECT, DELETE, UPDATE, INSERT ON base_hotelaria.* TO 'grupo_gerente' WITH GRANT OPTION;
GRANT 'grupo_gerente' TO 'gt_rob';
SET DEFAULT ROLE 'grupo_gerente' FOR 'gt_rob';

CREATE role 'grupo_recepcionista';
CREATE USER 'rcp_paulo' IDENTIFIED BY 'recep123';
GRANT SELECT, DELETE, UPDATE, INSERT ON base_hotelaria.cliente  TO 'grupo_recepcionista';
GRANT SELECT, DELETE, UPDATE, INSERT ON base_hotelaria.reserva  TO 'grupo_recepcionista';
GRANT SELECT, DELETE, UPDATE, INSERT ON base_hotelaria.hospedagem  TO 'grupo_recepcionista';
GRANT 'grupo_recepcionista' TO 'rcp_paulo';
SET DEFAULT ROLE 'grupo_recepcionista' FOR 'rcp_paulo';

CREATE role 'grupo_atd_geral';
CREATE USER 'atd_wesley' IDENTIFIED BY 'atdgl123';
CREATE USER 'atd_joao' IDENTIFIED BY 'atdgl456';
CREATE USER 'atd_marina' IDENTIFIED BY 'atdgl789';
CREATE VIEW view1 AS 
SELECT nr_quarto, nm_cliente FROM reserva JOIN cliente WHERE reserva.cd_cliente = cliente.cd_cliente;
GRANT SELECT ON base_hotelaria.view1 TO 'grupo_atd_geral';
GRANT INSERT ON base_hotelaria.hospedagem_servico TO 'grupo_atd_geral';
GRANT UPDATE ON base_hotelaria.hospedagem_servico TO 'grupo_atd_geral';
GRANT SELECT ON base_hotelaria.hospedagem_servico TO 'grupo_atd_geral';
GRANT 'grupo_atd_geral' TO 'atd_wesley', 'atd_joao', 'atd_marina';
SET DEFAULT ROLE 'grupo_atd_geral' FOR 'atd_wesley';


ALTER TABLE hospedagem
modify COLUMN cd_hospedagem INTeger AUTO_INCREMENT;
SET DEFAULT ROLE 'grupo_atd_geral' FOR 'atd_joao';
SET DEFAULT ROLE 'grupo_atd_geral' FOR 'atd_marina';