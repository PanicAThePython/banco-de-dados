#Natália Sens Weise, 5sem, BCC

# a)criar uma rotina que sinalize (liste) a disponibilidade de quarto(s), 
# ou seja sem reserva, considerando uma determinada data passada com parâmetro;
delimiter $
CREATE OR REPLACE procedure listagem_quartos_disponiveis(dia DATE)
BEGIN
SELECT DISTINCT quarto.* FROM quarto JOIN reserva WHERE quarto.nr_quarto <> reserva.nr_quarto AND dia <> reserva.dt_reserva;
END;
CALL listagem_quartos_disponiveis('2022-05-06');

#b) criar uma rotina para adicionar uma hospedagem passando como parâmetros: cliente, quarto, data de entrada e data prevista de saída. 
#Utilizar cd_funcionario (1) visto que não teremos controle de autenticação, e fl_situacao ('O') para ocupado;
delimiter $
CREATE OR REPLACE PROCEDURE adicionar_hospedagem(cod_cli INTEGER, cod_qrt INTEGER, dt_ent DATE, dt_sd DATE)
BEGIN
INSERT INTO hospedagem(dt_entrada, dt_saida, fl_situacao, cd_cliente, cd_funcionario, nr_quarto)
VALUES (dt_ent, dt_sd, 'O', cod_cli, 1, cod_qrt);
END;
CALL adicionar_hospedagem(1, 12, '2022-06-01', '2022-06-08');


#c) criar uma rotina para adicionar um serviço a uma determinada hospedagem. 
# Considerar os seguintes parâmetros: identificação da hospedagem e serviço;
# Atenção para a data de solicitação que deve ser a atual e o número de sequência 
# (que deve seguir incremental apenas dentro do número da hospedagem, ou seja, este número é zerado para cada nova hospedagem);
delimiter $
CREATE OR REPLACE PROCEDURE adicionar_servico_a_hospedagem(cod_hosp INTEGER, cod_ser INTEGER)
BEGIN
INSERT INTO hospedagem_servico(cd_hospedagem, cd_servico, dt_solicitacao)
VALUES (cod_hosp, cod_ser, curdate());
END;
CALL adicionar_servico_a_hospedagem(1, 1);

#d) criar uma rotina para mudar o status (coluna fl_situacao) para 'F' - finalizada. 
# Esta rotina deverá receber como parâmetro o identificador da hospedagem;
delimiter $
CREATE OR REPLACE PROCEDURE mudar_status_hospedagem(cod_hosp INTEGER)
BEGIN
UPDATE hospedagem SET fl_situacao = 'F' 
WHERE cd_hospedagem = cod_hosp;
END;
CALL mudar_status_hospedagem(1);


# e) manter um log com todas as operações DML realizadas nas tabelas hospedagem e hospedagem_servico. 
# Dica, criar uma tabela e registrar os eventos (logs)...;

CREATE TABLE registro(
	dia DATE,
	hora TIME,
	info VARCHAR(100)
);


DELIMITER $$
CREATE TRIGGER registro_insert_hospedagem AFTER INSERT ON hospedagem
FOR EACH ROW
BEGIN
Insert into registro VALUES (CURDATE(), CURTIME(),CONCAT('Inserção de hospedagem -> Hospedagem ',NEW.cd_hospedagem,' adicionada'));
END;

DELIMITER $$
CREATE TRIGGER registro_update_hospedagem AFTER UPDATE ON hospedagem
FOR EACH ROW
BEGIN
Insert into registro VALUES (CURDATE(), CURTIME(),CONCAT('Atualização de hospedagem -> Hospedagem ',NEW.cd_hospedagem,' atualizada'));
END;

DELIMITER $$
CREATE TRIGGER registro_delete_hospedagem AFTER UPDATE ON hospedagem
FOR EACH ROW
BEGIN
Insert into registro VALUES (CURDATE(), CURTIME(),CONCAT('Exclusão de hospedagem -> Hospedagem ',NEW.cd_hospedagem,' excluída'));
END;

DELIMITER $$
CREATE TRIGGER registro_insert_hospedagem_servico AFTER INSERT ON hospedagem_servico
FOR EACH ROW
BEGIN
Insert into registro VALUES (CURDATE(), CURTIME(),CONCAT('Inserção de hospedagem-serviço -> Hospedagem ',NEW.cd_hospedagem,' e Serviço ',NEW.cd_servico, ' inseridos na tabela'));
END;

DELIMITER $$
CREATE TRIGGER registro_update_hospedagem_servico AFTER UPDATE ON hospedagem_servico
FOR EACH ROW
BEGIN
Insert into registro VALUES (CURDATE(), CURTIME(),CONCAT('Atualização de hospedagem-serviço -> Hospedagem ',NEW.cd_hospedagem,' e Serviço ',NEW.cd_servico, ' atualizados'));
END;

DELIMITER $$
CREATE TRIGGER registro_delete_hospedagem_servico AFTER DELETE ON hospedagem_servico
FOR EACH ROW
BEGIN
Insert into registro VALUES (CURDATE(), CURTIME(),CONCAT('Exclusão de hospedagem-serviço -> Hospedagem ',NEW.cd_hospedagem,' e Serviço ',NEW.cd_servico, ' excluídos da tabela'));
END;

