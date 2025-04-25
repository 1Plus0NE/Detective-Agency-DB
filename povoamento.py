import mysql.connector


conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='',
    database='AgenciaDetetivesSr.Alfredo'
)

cursor = conn.cursor()

cursor.execute("""
INSERT INTO clientes (nome, sexo, dta_nascimento, email, nif, rua, cod_postal, localidade, concelho)
VALUES
('Paulo Oliveira', 'M', '1975-01-15', 'paulo.oliveira@gmail.com', 223456789, 'Rua Afonso Pena', '4567-890', 'Lisboa', 'Lisboa'),
('Fernanda Costa', 'F', '1982-04-12', 'fernanda.costa@gmail.com', 334567890, 'Avenida da Liberdade', '5678-901', 'Lisboa', 'Lisboa'),
('Ricardo Pereira', 'M', '1992-07-21', 'ricardo.pereira@gmail.com', 445678901, 'Rua das Flores', '6789-012', 'Porto', 'Porto')
""")

cursor.execute("""
INSERT INTO cliente_telemoveis (telemovel, idCliente)
VALUES
('945678901', 4),
('956789012', 5),
('967890123', 6)
""")

cursor.execute("""
INSERT INTO tipos (Designacao, descricao)
VALUES
('Contra-espionagem', 'Casos de contra-espionagem'),
('Investigação Corporativa', 'Investigações dentro de empresas'),
('Segurança Residencial', 'Serviços de segurança residencial')
""")

cursor.execute("""
INSERT INTO casos (estado, custo_agencia, desginacao, descricao, dta_inicio, dta_conclusao, Cliente, Tipo)
VALUES
('E', 6000, 'Espionagem Industrial', 'Investigação de espionagem dentro de uma empresa', '2024-05-01', NULL, 4, 4),
('C', 4000, 'Segurança para VIP', 'Serviço de segurança para pessoa importante', '2024-06-01', NULL, 5, 5),
('T', 8000, 'Segurança Residencial', 'Serviço de segurança para residência de luxo', '2024-07-01', '2024-08-01', 6, 6)
""")

cursor.execute("""
INSERT INTO detetives (Nome, telemovel, email, estado, detetiveChefe)
VALUES
('Luís Mendes', 944556677, 'luis.mendes@gmail.com', 'A', 1)
""")

cursor.execute(f"""
INSERT INTO detetives (Nome, telemovel, email, estado, detetiveChefe)
VALUES
('Carlos Martins', 955667788, 'carlos.martins@gmail.com', 'A', 1),
('Sofia Almeida', 966778899, 'sofia.almeida@gmail.com', 'I', 1)
""")

cursor.execute("""
INSERT INTO caso_detetive (caso, detetive)
VALUES
(4, 4),
(5, 5),
(6, 6)
""")

cursor.execute("""
INSERT INTO evidencias (designacao, data_coleta, caso, detetive)
VALUES
('Documentos Confidenciais', '2024-05-15', 4, 4),
('Gravações de Áudio', '2024-06-20', 5, 5),
('Fotografias', '2024-07-25', 6, 6)
""")

cursor.execute("""
INSERT INTO fotografias (fotografia, evidencia)
VALUES
('doc1.jpg', 4),
('audio1.mp3', 5),
('foto4.jpg', 6)
""")

conn.commit()

cursor.close()
conn.close()
