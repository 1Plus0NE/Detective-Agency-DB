DELIMITER $$

/* Adiciona cliente novo*/

CREATE PROCEDURE AdicionarCliente(
    IN nome VARCHAR(100), 
    IN sexo VARCHAR(45), 
    IN dta_nascimento DATE, 
    IN email VARCHAR(100), 
    IN nif INT, 
    IN rua VARCHAR(100), 
    IN cod_postal VARCHAR(9), 
    IN localidade VARCHAR(250), 
    IN concelho VARCHAR(100))
BEGIN
    INSERT INTO clientes (nome, sexo, dta_nascimento, email, nif, rua, cod_postal, localidade, concelho)
    VALUES (nome, sexo, dta_nascimento, email, nif, rua, cod_postal, localidade, concelho);
END$$


/* Atualiza cliente*/

CREATE PROCEDURE AdicionarClienteComTelemoveis(
    IN nome VARCHAR(100), 
    IN sexo VARCHAR(45), 
    IN dta_nascimento DATE, 
    IN email VARCHAR(100), 
    IN nif INT, 
    IN rua VARCHAR(100), 
    IN cod_postal VARCHAR(9), 
    IN localidade VARCHAR(250), 
    IN concelho VARCHAR(100), 
    IN telemovel1 VARCHAR(15)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO clientes (nome, sexo, dta_nascimento, email, nif, rua, cod_postal, localidade, concelho)
    VALUES (nome, sexo, dta_nascimento, email, nif, rua, cod_postal, localidade, concelho);
    
    SET @idCliente = LAST_INSERT_ID();
    
    INSERT INTO cliente_telemoveis (telemovel, idCliente) VALUES (telemovel1, @idCliente);
    
    COMMIT;
END$$


-- Elimina cliente baseado no id

CREATE PROCEDURE EliminarClienteComDadosRelacionados(IN clienteID INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    
    DELETE FROM cliente_telemoveis WHERE idCliente = clienteID;
    DELETE FROM clientes WHERE idCliente = clienteID;
    
    COMMIT;
END$$

-- inserir um novo detetive

CREATE PROCEDURE AdicionarDetetive(
    IN Nome VARCHAR(200), 
    IN telemovel INT, 
    IN email VARCHAR(100), 
    IN estado CHAR(1), 
    IN detetiveChefe INT)
BEGIN
    INSERT INTO detetives (Nome, telemovel, email, estado, detetiveChefe)
    VALUES (Nome, telemovel, email, estado, detetiveChefe);
END$$

-- atualizar um detetive
CREATE PROCEDURE EditarDetetive(
    IN detetiveID INT,
    IN Nome VARCHAR(200), 
    IN telemovel INT, 
    IN email VARCHAR(100), 
    IN estado CHAR(1), 
    IN detetiveChefe INT)
BEGIN
    UPDATE detetives 
    SET 
        Nome = Nome, 
        telemovel = telemovel, 
        email = email, 
        estado = estado, 
        detetiveChefe = detetiveChefe
    WHERE 
        idDetetive = detetiveID;
END$$

-- eliminar um detetive

CREATE PROCEDURE EliminarDetetive(IN detetiveID INT)
BEGIN
    DELETE FROM detetives WHERE idDetetive = detetiveID;
END$$

-- funcao para calcular a idade

CREATE FUNCTION CalcularIdade(dta_nascimento DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE idade INT;
    SET idade = TIMESTAMPDIFF(YEAR, dta_nascimento, CURDATE());
    RETURN idade;
END$$

-- trigger para criar fatura ao inserir um caso

CREATE TRIGGER AfterInsertCaso
AFTER INSERT ON casos
FOR EACH ROW
BEGIN
    INSERT INTO faturas (dta_emissao, valor, cliente, caso)
    VALUES (NOW(), NEW.custo_agencia * 1.5, NEW.Cliente, NEW.idCaso);
END$$

CREATE VIEW MonthlyInvoiceReport AS
SELECT 
    DATE_FORMAT(f.dta_emissao, '%Y-%m') AS mes_ano,
    COUNT(DISTINCT f.caso) AS numero_casos_analisados,
    COUNT(DISTINCT cd.detetive) AS numero_detetives_envolvidos,
    SUM(f.valor) AS valor_total_faturado
FROM 
    faturas f
    LEFT JOIN caso_detetive cd ON f.caso = cd.caso
GROUP BY 
    DATE_FORMAT(f.dta_emissao, '%Y-%m');

CREATE VIEW MonthlyProfit AS
SELECT 
    DATE_FORMAT(f.dta_pagamento, '%Y-%m') AS mes_ano,
    SUM(f.valor) - SUM(c.custo_agencia) AS lucro
FROM 
    faturas f
    INNER JOIN casos c ON f.caso = c.idCaso
WHERE 
    f.dta_pagamento IS NOT NULL
GROUP BY 
    DATE_FORMAT(f.dta_pagamento, '%Y-%m')
ORDER BY 
    mes_ano;

CREATE VIEW CasesWithMostDetectives AS
SELECT 
    c.idCaso,
    c.desginacao AS designacao_caso,
    c.descricao,
    COUNT(cd.detetive) AS numero_detetives
FROM 
    casos c
    INNER JOIN caso_detetive cd ON c.idCaso = cd.caso
GROUP BY 
    c.idCaso,
    c.desginacao,
    c.descricao
ORDER BY 
    numero_detetives DESC;

select * from MonthlyInvoiceReport;

select * from casos;

select * from faturas;

select * from MonthlyProfit;

select * from CasesWithMostDetectives;
