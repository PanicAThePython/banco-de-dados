SELECT USER();

SELECT nm_funcionario, ds_cargo FROM funcionario JOIN cargo 
WHERE funcionario.cd_cargo = cargo.cd_cargo;

INSERT INTO funcionario(cd_funcionario, nm_funcionario, cd_cargo)
VALUES (6, 'Luana', 4);

UPDATE funcionario SET nm_funcionario='Luana Rosa' WHERE cd_funcionario=6;

DELETE FROM funcionario WHERE cd_funcionario=6;