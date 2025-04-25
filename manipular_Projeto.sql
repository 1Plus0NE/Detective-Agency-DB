
/*
A qualquer momento, o sistema deve
apresentar um relatório de faturas
mensais, com o número de casos ana-
lisados, o número de detetives envol-
vidos e o valor total faturado.
*/
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

/*
A qualquer momento, o sistema deve
listar todos os casos solicitados por
um cliente.
*/
SELECT
	cl.nome,
    c.idCaso,
    c.desginacao AS designacao,
    c.descricao,
    c.estado,
    c.custo_agencia,
    c.dta_inicio,
    c.dta_conclusao,
    t.Designacao AS tipo
FROM 
    casos c
    INNER JOIN clientes cl ON c.Cliente = cl.idCliente
    INNER JOIN tipos t ON c.Tipo = t.idTipo
WHERE 
    cl.idCliente = 1;

-- Deve ser possível saber quantos casos houve num mês.
SELECT 
    DATE_FORMAT(dta_inicio, '%Y-%m') AS mes_ano,
    COUNT(*) AS numero_casos
FROM 
    casos
WHERE 
    DATE_FORMAT(dta_inicio, '%Y-%m') = '2024-01'
GROUP BY 
    DATE_FORMAT(dta_inicio, '%Y-%m');


-- lista de clientes ordenada por nif
SELECT *FROM clientes
ORDER BY 
    nif;

-- Deve ser possível consultar todos os detetives envolvidos num caso.
SELECT 
    d.idDetetive,
    d.Nome,
    d.telemovel,
    d.email,
    d.estado,
    d.detetiveChefe
FROM 
    caso_detetive cd
    INNER JOIN detetives d ON cd.detetive = d.idDetetive
WHERE 
    cd.caso = 2;

-- Deve ser possível saber quantos casos um detetive esteve envolvido num mês
SELECT 
    d.idDetetive,
    d.Nome,
    DATE_FORMAT(c.dta_inicio, '%Y-%m') AS mes_ano,
    COUNT(DISTINCT c.idCaso) AS numero_casos
FROM 
    caso_detetive cd
    INNER JOIN detetives d ON cd.detetive = d.idDetetive
    INNER JOIN casos c ON cd.caso = c.idCaso
GROUP BY 
    d.idDetetive,
    DATE_FORMAT(c.dta_inicio, '%Y-%m')
ORDER BY 
    d.idDetetive;


-- Deve ser possível consultar as evidências recolhidas por um detetive.
SELECT 
    e.idEvidencia,
    e.designacao,
    e.data_coleta,
    e.caso,
    e.detetive
FROM 
    evidencias e
    INNER JOIN detetives d ON e.detetive = d.idDetetive
WHERE 
    d.idDetetive = 1;

-- Deve ser possível saber quantas evidências um caso teve.
SELECT 
    c.idCaso,
    c.desginacao AS designacao,
    COUNT(e.idEvidencia) AS numero_evidencias
FROM 
    casos c
    LEFT JOIN evidencias e ON c.idCaso = e.caso
GROUP BY 
    c.idCaso, c.desginacao;

-- A qualquer momento, o sistema deve listar todos os casos da agência, ordenados pelo o seu tipo.
SELECT 
    c.idCaso,
    c.desginacao AS designacao,
    c.descricao,
    c.estado,
    c.custo_agencia,
    c.dta_inicio,
    c.dta_conclusao,
    t.designacao AS tipo
FROM 
    casos c
    INNER JOIN tipos t ON c.Tipo = t.idTipo
ORDER BY 
    t.designacao;

-- Deve ser possível consultar o histórico de casos de um detetive.
SELECT 
    d.idDetetive,
    d.Nome AS nome_detetive,
    c.idCaso,
    c.desginacao AS designacao_caso,
    c.descricao,
    c.estado,
    c.custo_agencia,
    c.dta_inicio,
    c.dta_conclusao,
    t.Designacao AS tipo
FROM 
    detetives d
    INNER JOIN caso_detetive cd ON d.idDetetive = cd.detetive
    INNER JOIN casos c ON cd.caso = c.idCaso
    INNER JOIN tipos t ON c.Tipo = t.idTipo
WHERE 
    d.idDetetive = 1
ORDER BY 
    c.dta_inicio DESC;
    
-- Listar todas as evidências ordenadas pela data de coleta
SELECT 
    e.idEvidencia,
    e.designacao,
    e.data_coleta,
    e.caso,
    e.detetive
FROM 
    evidencias e
ORDER BY 
    e.data_coleta;

-- Deve ser possível saber os casos que envolveram mais detetives.
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

-- A qualquer momento, o sistema deve listar todos os detetives pelo o seu estado.
SELECT 
    d.idDetetive,
    d.Nome,
    d.telemovel,
    d.email,
    d.estado,
    d.detetiveChefe
FROM 
    detetives d
ORDER BY 
    d.estado;

-- A qualquer momento, o sistema deve listar todos os casos ordenados por estado (em execução, suspenso ou terminado)
SELECT 
    c.idCaso,
    c.desginacao AS designacao,
    c.descricao,
    c.estado,
    c.custo_agencia,
    c.dta_inicio,
    c.dta_conclusao,
    t.Designacao AS tipo
FROM 
    casos c
    INNER JOIN tipos t ON c.Tipo = t.idTipo
ORDER BY
	c.estado;

-- A qualquer momento, o sistema deve listar todas as faturas já emitidas
SELECT 
    f.idFatura,
    f.dta_emissao,
    f.dta_pagamento,
    f.valor,
    c.nome AS nome_cliente,
    cs.desginacao AS designacao_caso
FROM 
    faturas f
    INNER JOIN clientes c ON f.cliente = c.idCliente
    INNER JOIN casos cs ON f.caso = cs.idCaso;


-- A qualquer momento, o sistema deve listar todas as faturas pagas
SELECT 
    f.idFatura,
    f.dta_emissao,
    f.dta_pagamento,
    f.valor,
    c.nome AS nome_cliente,
    cs.desginacao AS designacao_caso
FROM 
    faturas f
    INNER JOIN clientes c ON f.cliente = c.idCliente
    INNER JOIN casos cs ON f.caso = cs.idCaso
WHERE 
    f.dta_pagamento IS NOT NULL
ORDER BY 
    f.dta_pagamento DESC;


-- A qualquer momento, o sistema deve ser capaz de calcular o lucro obtido num mês
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

-- A qualquer momento, o sistema deve listar todas as faturas por pagar
SELECT 
    f.idFatura,
    f.dta_emissao,
    f.valor,
    c.nome AS nome_cliente,
    cs.desginacao AS designacao_caso
FROM 
    faturas f
    INNER JOIN clientes c ON f.cliente = c.idCliente
    INNER JOIN casos cs ON f.caso = cs.idCaso
WHERE 
    f.dta_pagamento IS NULL
ORDER BY 
    f.dta_emissao DESC;

-- select para ver a idade de todos os clientes
SELECT 
    idCliente,
    nome,
    dta_nascimento,
    CalcularIdade(dta_nascimento) AS idade
FROM 
    clientes;

-- update estado fatura
UPDATE faturas
SET dta_pagamento = NOW()
WHERE dta_pagamento IS NULL;

select * from faturas;

select * from clientes;

select * from caso_detetive;

select * from tipos;

select * from casos;


