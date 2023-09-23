SELECT USER();

INSERT INTO hospedagem_servico(cd_hospedagem, cd_servico, nr_sequencia, dt_solicitacao)
VALUES (1, 1, 1, '2022-05-13');

UPDATE hospedagem_servico SET dt_solicitacao = '2022-05-14' 
WHERE nr_sequencia = 1;