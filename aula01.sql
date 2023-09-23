CREATE TABLE departamento
(
	cd_depto INTEGER,
	nm_depto VARCHAR(30),
	vl_orcto DECIMAL(8,2),
	constraint departamento_pk PRIMARY KEY (cd_depto)
);

CREATE TABLE funcionario
(
	cd_func  INTEGER,
	cd_depto INTEGER,
	nm_func  VARCHAR(30),
	CONSTRAINT funcionario_pk PRIMARY KEY (cd_func),
	CONSTRAINT funcionario_cd_depto_fk FOREIGN KEY (cd_depto)
		REFERENCES departamento(cd_depto)
);

bd_materialSELECT table_schema, table_name
FROM information_schema.`TABLES`
WHERE table_schema = 'bd_material'

INSERT INTO departamento VALUES (100,'Marketing', 10000);
INSERT INTO funcionario (cd_func, cd_depto, nm_func) VALUES (1001, 200,'José');

SELECT * FROM funcionario

CREATE TABLE FUNCIONARIO_MYISAM
(CD_FUNC INTEGER,
CD_DEPTO INTEGER,
NM_FUNC VARCHAR(50),
PRIMARY KEY (CD_FUNC),
FOREIGN KEY (CD_DEPTO)
REFERENCES DEPARTAMENTO_MYISAM(CD_DEPTO)
)ENGINE = MYISAM;

CREATE TABLE DEPARTAMENTO_MYISAM
(CD_DEPTO INTEGER,
NM_DEPTO VARCHAR(50),
VL_ORCTO DECIMAL(8,2),
PRIMARY KEY (CD_DEPTO)
)
ENGINE=MYISAM;

insert into DEPARTAMENTO_myisam (CD_DEPTO, NM_DEPTO, VL_ORCTO)
values (100,'Marketing',10000.00);


SELECT * FROM departamento_myisam;

insert into FUNCIONARIO_myisam (CD_FUNC, CD_DEPTO, NM_FUNC)
values (1001, 100, 'Maria');

SELECT * FROM funcionario_myisam;

SELECT * FROM log_bairro WHERE ufe_sg='SC';
SELECT * FROM log_grande_usuario;
SELECT * FROM log_localidade;
SELECT loc_nosub FROM log_localidade ORDER BY loc_nosub;
SELECT * from log_logradouro WHERE log_no='BR-101'; base_hotelaria