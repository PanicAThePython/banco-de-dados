CREATE TABLE categoria
(cd_categoria INTEGER,
nm_categoria VARCHAR(50),
PRIMARY KEY (cd_categoria)
);


CREATE TABLE produto
(cd_produto INTEGER,
nm_produto VARCHAR(50),
qt_estoque INTEGER,
cd_categoria INTEGER REFERENCES categoria(cd_categoria),
PRIMARY KEY (cd_produto)
);

INSERT INTO categoria (cd_categoria, nm_categoria)
VALUES (1, 'categoria 1');

INSERT INTO categoria (cd_categoria, nm_categoria)
VALUES (2, 'categoria 2');

INSERT INTO categoria (cd_categoria, nm_categoria)
VALUES (3, 'categoria 3');

INSERT INTO categoria (cd_categoria, nm_categoria)
VALUES (4, 'categoria 4');

CREATE USER 'usuario1' IDENTIFIED BY 'u1';

GRANT CREATE ON base_testes.* TO 'usuario1';

GRANT SELECT ON base_testes.categoria TO 'usuario1';
