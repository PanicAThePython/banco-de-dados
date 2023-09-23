SELECT USER();

SELECT nr_reserva AS numero_reserva, nm_cliente AS nome_cliente
FROM reserva JOIN cliente
WHERE reserva.cd_cliente = cliente.cd_cliente;

SELECT * FROM cliente;

INSERT INTO cliente(cd_cliente, nm_cliente, ds_email, nr_telefone)
VALUES (3, 'Luiza', 'luiza456@gmail.com', '47933333333');

UPDATE cliente SET nr_telefone='47999999999'
WHERE cd_cliente=3;

DELETE FROM cliente WHERE cd_cliente=2;

DELETE FROM funcionario WHERE cd_funcionario=1;