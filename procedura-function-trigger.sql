UPDATE hospedagem_servico SET dt_solicitacao='2022-05-14'
WHERE nr_sequencia = 1;

DROP TABLE hospedagem_servico;base_cep_brasilbase_testes_pl

CREATE TABLE registro_log
(data DATE,
hora TIME,
usuario VARCHAR(30),
operacao VARCHAR(100)
);

CREATE TABLE teste
(cd_teste INTEGER,
nm_teste VARCHAR(50),
ds_teste VARCHAR(50),
PRIMARY KEY (cd_teste)
);


-- sintaxe de criação trigger
delimiter $
CREATE OR REPLACE TRIGGER tgr_teste_insert AFTER INSERT ON teste
FOR EACH ROW
BEGIN
INSERT INTO registro_log (DATA, hora, usuario, operacao)
VALUES (CURDATE(),CURTIME(),USER(),CONCAT('inserção ID: ',NEW.cd_teste));
END;


SELECT * FROM registro_log;
SELECT * FROM teste;
INSERT INTO teste (cd_teste, nm_teste, ds_teste) VALUES (1,'nome 1','descrição 1');



-- recuperando as trigger da base de dados...
SELECT * FROM information_schema.`TRIGGERS` WHERE trigger_schema = 'base_testes_pl'


-- criação de trigger para inserir informação no log
delimiter $ -- serve para alterar o caracter que encerra do comando
CREATE OR REPLACE TRIGGER tgr_teste_update AFTER UPDATE ON teste
FOR EACH ROW
BEGIN
INSERT INTO registro_log (DATA, hora, usuario, operacao)
VALUES (CURDATE(),CURTIME(),USER(),CONCAT('alteração ID: ',OLD.cd_teste,' -> ',NEW.cd_teste));
END;

INSERT INTO teste (cd_teste, nm_teste, ds_teste) VALUES (2,'nome 2','descrição 2');

UPDATE teste SET cd_teste = 11 WHERE cd_teste = 1;


DELETE FROM teste WHERE cd_teste = 11;


delimiter $ -- serve para alterar o caracter que encerra do comando
CREATE OR REPLACE TRIGGER tgr_teste_delete AFTER DELETE ON teste
FOR EACH ROW
BEGIN
INSERT INTO registro_log (DATA, hora, usuario, operacao)
VALUES (CURDATE(),CURTIME(),USER(),CONCAT('exclusão ID: ',OLD.cd_teste));
END;




CREATE TABLE Medicamento (
cd_medicamento integer AUTO_INCREMENT,
nm_medicamento varchar(50) ,
ds_medicamento varchar(200) ,
vl_custo decimal(8,2) ,
vl_venda decimal(8,2) ,
qt_estoque integer ,
PRIMARY KEY (cd_medicamento)
);



CREATE TABLE NotaFiscal (
nr_notafiscal integer AUTO_INCREMENT ,
dt_emissao date ,
vl_total decimal(8,2) ,
PRIMARY KEY (nr_notafiscal)
);



CREATE TABLE ItemNotaFiscal (
nr_notafiscal integer,
cd_medicamento integer,
qt_vendida integer,
vl_venda decimal(8,2),
PRIMARY KEY (nr_notafiscal, cd_medicamento),
FOREIGN KEY (nr_notafiscal) REFERENCES Notafiscal(nr_notafiscal),
FOREIGN KEY (cd_medicamento) REFERENCES Medicamento(cd_medicamento)
);

DROP TABLE ItemNotaFiscal;
DROP TABLE Medicamento;
DROP TABLE NotaFiscal;


INSERT INTO Medicamento VALUES (1, 'Benegripe', 'Remédio pra gripe', 5.0, 10.0, 11);
INSERT INTO Medicamento VALUES (2, 'Aspirina C', 'Remédio pra aumentar a resistência', 7.0, 11.0, 22);
INSERT INTO Medicamento VALUES (3, 'Dermatos', 'Remédio pra dores', 20.0, 30.0, 33);
INSERT INTO Medicamento VALUES (4, 'Cataflan', 'Remédio pra dor de garganta', 10.0, 15.0, 44);
INSERT INTO Medicamento VALUES (5, 'Remédio 5', 'Remédio pra dores na barriga', 35.0, 50.0, 55);
INSERT INTO Medicamento VALUES (6, 'Benegripe Genérico', 'Remédio pra gripe genérico', 9.0, 15.0, 66);
INSERT INTO Medicamento VALUES (7, 'Dermatos Genérico', 'Remédio pra dores genérico', 50.0, 70.0, 77);
INSERT INTO Medicamento VALUES (8, 'Vodol 50mg','Remédio para micose',21.20, 28.90, 30);
INSERT INTO Medicamento VALUES (9, 'Vick' ,'Pastilha para garganta',11.50, 17.50, 80);
INSERT INTO Medicamento VALUES (10, 'Doralgina','Remédio para dor de cabeça',9.90, 15, 10);




-- sintaxe de criação de um FUCTION
CREATE OR REPLACE FUNCTION <nome_da_função> (<parâmetros>) RETURNS tipo_dado
BEGIN
-- instruções da função - corpo
END;



delimiter $
CREATE OR REPLACE FUNCTION conta_medicamentos() RETURNS INTEGER
BEGIN
DECLARE total INTEGER;
SELECT COUNT(*) INTO total FROM medicamento;
RETURN total;
END;


SELECT conta_medicamentos()


-- criação de um função para retornar a quantidade de medicamento em estoque e o valor
delimiter $
CREATE or replace FUNCTION busca_medicamento(codigo INTEGER, out preco DECIMAL) RETURNS INTEGER
READS SQL DATA
BEGIN
DECLARE estoque INTEGER;
SELECT qt_estoque, vl_venda INTO estoque, preco
FROM medicamento
WHERE cd_medicamento = codigo;
RETURN estoque;
END;



SELECT busca_medicamento(1,@valor)
SELECT @valor

-- criação de um função para retornar a quantidade de medicamento em estoque e o valor
delimiter $
CREATE or replace FUNCTION busca_medicamento(codigo INTEGER, out preco DECIMAL) RETURNS INTEGER
READS SQL DATA
BEGIN
DECLARE estoque INTEGER;
SELECT qt_estoque, vl_venda INTO estoque, preco
FROM medicamento
WHERE cd_medicamento = codigo;
RETURN estoque;
END;



SELECT busca_medicamento(1,@valor)
SELECT @valor

delimiter $
CREATE or replace FUNCTION busca_medicamento(codigo INTEGER) RETURNS INTEGER
READS SQL DATA
BEGIN
DECLARE estoque INTEGER;
SELECT qt_estoque INTO estoque
FROM medicamento
WHERE cd_medicamento = codigo;
if estoque = 11 then
set estoque = estoque + 100;
END if;
RETURN estoque;
END;



SELECT busca_medicamento(1)

-- função para criar/inserir uma nota fiscal
delimiter $
CREATE or REPLACE FUNCTION cria_nf() RETURNS INTEGER
BEGIN
INSERT INTO notafiscal(dt_emissao, vl_total)
VALUES (CURDATE(), NULL);
RETURN LAST_INSERT_ID();
END;
SELECT cria_nf();


-- criação de uma procedure para inserir produtos em uma NF
delimiter $
CREATE OR REPLACE procedure insere_item_nf(IN nf INTEGER, med INTEGER, qtde INTEGER, valor DECIMAL)
BEGIN
INSERT INTO itemnotafiscal (nr_notafiscal, cd_medicamento, qt_vendida, vl_venda)
VALUES (nf, med, qtde, valor);
END;
CALL insere_item_nf(1,1,2,10);

-- criação de uma procedure para inserir produtos em uma NF
delimiter $
CREATE OR REPLACE procedure insere_item_nf2(IN nf INTEGER, med INTEGER, qtde INTEGER)
BEGIN
DECLARE valor_produto DECIMAL(8,2) DEFAULT 0;
SELECT vl_venda INTO valor_produto FROM medicamento WHERE cd_medicamento = med;
INSERT INTO itemnotafiscal (nr_notafiscal, cd_medicamento, qt_vendida, vl_venda)
VALUES (nf, med, qtde, valor_produto);
END;


-- chamada para a procedure
CALL insere_item_nf2(2,7,2);


DESCRIBE medicamento
DESCRIBE itemnotafiscal



-- criação de uma trigger para atualizar o estoque do medicamento
delimiter $
CREATE OR REPLACE TRIGGER tgr_venda_medicamento AFTER INSERT ON itemnotafiscal
FOR EACH ROW
BEGIN
UPDATE medicamento
SET qt_estoque = qt_estoque - NEW.qt_vendida -- NEW.qt_vendida é o valor do campo na tabela itemnotafiscal
WHERE cd_medicamento = NEW.cd_medicamento; -- NEW.cd_medicamento é o valor do campo na tabela itemnotafiscal
END;

-- chamada para a procedure
CALL insere_item_nf2(1,5,4);


-- criação de uma trigger para atualizar o estoque do medicamento
delimiter $
CREATE OR REPLACE TRIGGER tgr_venda_medicamento AFTER INSERT ON itemnotafiscal
FOR EACH ROW
BEGIN
DECLARE qtde INTEGER DEFAULT 0;
DECLARE valor DECIMAL DEFAULT 0.0;
set qtde = New.qt_vendida;
set valor = New.vl_venda;
UPDATE medicamento
SET qt_estoque = qt_estoque - qtde -- NEW.qt_vendida é o valor do campo na tabela itemnotafiscal
WHERE cd_medicamento = NEW.cd_medicamento; -- NEW.cd_medicamento é o valor do campo na tabela itemnotafiscal
-- atualizando também o valor total da NF
UPDATE notafiscal
-- SET vl_total = vl_total + (qtde * valor)
SET vl_total = vl_total + 1111
WHERE nr_notafiscal = NEW.nr_notafiscal;
END;

-- criação de uma trigger para atualizar o estoque do medicamento
delimiter $
CREATE OR REPLACE TRIGGER tgr_venda_medicamento AFTER INSERT ON itemnotafiscal
FOR EACH ROW
BEGIN
DECLARE qtde INTEGER DEFAULT 0;
DECLARE valor DECIMAL DEFAULT 0.0;
set qtde = New.qt_vendida;
set valor = New.vl_venda;
UPDATE medicamento
SET qt_estoque = qt_estoque - qtde -- NEW.qt_vendida é o valor do campo na tabela itemnotafiscal
WHERE cd_medicamento = NEW.cd_medicamento; -- NEW.cd_medicamento é o valor do campo na tabela itemnotafiscal
-- atualizando também o valor total da NF
UPDATE notafiscal
SET vl_total = vl_total + (qtde * valor)
WHERE nr_notafiscal = NEW.nr_notafiscal;
END;
