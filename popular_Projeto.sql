USE `AgenciaDetetivesSr.Alfredo`;

/* Inserindo dados na tabela clientes */
INSERT INTO clientes (nome, sexo, dta_nascimento, email, nif, rua, cod_postal, localidade, concelho)
VALUES
('João Silva', 'M', '1980-01-01', 'joao.silva@gmail.com', 123456789, 'Rua Antonio Edgar', '1234-567', 'Aveiro', 'Aveiro'),
('Maria Santos', 'F', '1985-02-02', 'maria.santos@gmail.com', 987654321, 'Rua Jose Salina', '2345-678', 'Rebordosa', 'Paredes'),
('Carlos Lima', 'M', '1990-03-03', 'carlos.lima@gmail.com', 112233445, 'Rua Pedro Jose Amaral', '3456-789', 'Porto', 'Porto');

/* Inserindo dados na tabela cliente_telemoveis */
INSERT INTO cliente_telemoveis (telemovel, idCliente)
VALUES
('912345678', 1),
('923456789', 2),
('934567890', 3);

/* Inserindo dados na tabela tipos */
INSERT INTO tipos (Designacao, descricao)
VALUES
('Investigação Criminal', 'Casos relacionados a crimes'),
('Busca e Vigilância', 'Serviços de busca e vigilância'),
('Segurança Pessoal', 'Serviços de segurança pessoal');

/* Inserindo dados na tabela casos */
INSERT INTO casos (estado, custo_agencia, desginacao, descricao, dta_inicio, dta_conclusao, Cliente, Tipo)
VALUES
('E', 5000, 'Investigação Roubo', 'Investigação sobre roubo de joias', '2024-01-01', NULL, 1, 1),
('C', 3000, 'Vigilância Suspeito', 'Vigilância de um suspeito de fraude', '2024-02-01', NULL, 2, 2),
('T', 7000, 'Segurança Executiva', 'Serviço de segurança para executivo', '2024-03-01', '2024-04-01', 3, 3);

/* Inserindo dados na tabela detetives */
INSERT INTO detetives (Nome, telemovel, email, estado, detetiveChefe)
VALUES
('Alfredo Sousa', 911223344, 'alfredo.sousa@gmail.com', 'A', 1),
('Miguel Costa', 922334455, 'miguel.costa@gmail.com', 'A', 1),
('Ana Pereira', 933445566, 'ana.pereira@gmail.com', 'I', 1);

/* Inserindo dados na tabela caso_detetive */
INSERT INTO caso_detetive (caso, detetive)
VALUES
(1, 1),
(2, 2),
(3, 3);

/* Inserindo dados na tabela evidencias */
INSERT INTO evidencias (designacao, data_coleta, caso, detetive)
VALUES
('Impressões Digitais', '2024-01-10', 1, 1),
('Vídeo de Vigilância', '2024-02-15', 2, 2),
('Documentos', '2024-03-20', 3, 3);

/* Inserindo dados na tabela fotografias */
INSERT INTO fotografias (fotografia, evidencia)
VALUES
('foto1.jpg', 1),
('foto2.jpg', 2),
('foto3.jpg', 3);

/* Consultando os dados inseridos */
SELECT * FROM clientes;
SELECT * FROM cliente_telemoveis;
SELECT * FROM tipos;
SELECT * FROM casos;
SELECT * FROM faturas;
SELECT * FROM detetives;
SELECT * FROM caso_detetive;
SELECT * FROM evidencias;
SELECT * FROM fotografias;

