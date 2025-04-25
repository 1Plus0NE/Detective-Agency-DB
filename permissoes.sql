DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'client_user1'@'localhost';
DROP USER IF EXISTS 'detective_user'@'localhost';

-- Criar utilizadores
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'client_user1'@'localhost' IDENTIFIED BY 'client123';
CREATE USER 'detective_user'@'localhost' IDENTIFIED BY 'detective123';

-- Conceder todas as permissões ao administrador no esquema completo
GRANT ALL PRIVILEGES ON `AgenciaDetetivesSr.Alfredo`.* TO 'admin_user'@'localhost';

-- RC1: Só o administrador pode gerar as faturas
GRANT ALL PRIVILEGES ON `AgenciaDetetivesSr.Alfredo`.`faturas` TO 'admin_user'@'localhost';

-- RC2 e RC6: Cada cliente pode apenas aceder aos seus dados pessoais e aos casos que solicitou
DELIMITER $$

CREATE PROCEDURE GetClientCases()
BEGIN
    DECLARE clientId INT;
    DECLARE currentUser VARCHAR(100);
    SET currentUser = USER();

    IF currentUser LIKE 'client_user%@localhost' THEN
        SET clientId = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(currentUser, 'client_user', -1), '@', 1) AS UNSIGNED);

        IF clientId > 0 THEN
            SELECT * FROM casos WHERE Cliente = clientId;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Formato inválido de ID de cliente';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acesso não autorizado';
    END IF;
END $$

CREATE PROCEDURE GetClientInfo()
BEGIN
    DECLARE clientId INT;
    DECLARE currentUser VARCHAR(100);
    SET currentUser = USER();

    IF currentUser LIKE 'client_user%@localhost' THEN
        SET clientId = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(currentUser, 'client_user', -1), '@', 1) AS UNSIGNED);

        IF clientId > 0 THEN
            SELECT * FROM clientes WHERE idCliente = clientId;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Formato inválido de ID de cliente';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acesso não autorizado';
    END IF;
END $$

DELIMITER ;

-- Conceder permissões de execução nos procedimentos aos clientes
GRANT EXECUTE ON PROCEDURE `AgenciaDetetivesSr.Alfredo`.`GetClientCases` TO 'client_user1'@'localhost';
GRANT EXECUTE ON PROCEDURE `AgenciaDetetivesSr.Alfredo`.`GetClientInfo` TO 'client_user1'@'localhost';

-- Conceder permissões básicas para permitir login e uso da base de dados aos clientes
GRANT USAGE ON *.* TO 'client_user1'@'localhost';
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`casos` TO 'client_user1'@'localhost';
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`clientes` TO 'client_user1'@'localhost';

-- RC3: Só o administrador pode criar/editar/eliminar informações de casos
GRANT ALL PRIVILEGES ON `AgenciaDetetivesSr.Alfredo`.`casos` TO 'admin_user'@'localhost';

-- RC4: Só o administrador pode criar/consultar/editar/eliminar informações de qualquer cliente. Cada cliente pode realizar o mesmo, mas apenas para as suas próprias informações
GRANT ALL PRIVILEGES ON `AgenciaDetetivesSr.Alfredo`.`clientes` TO 'admin_user'@'localhost';

-- RC5: Só o administrador e os detetives podem consultar as informações dos clientes
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`clientes` TO 'admin_user'@'localhost';
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`clientes` TO 'detective_user'@'localhost';

-- RC7: Só o administrador e os detetives podem consultar as informações de qualquer caso
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`casos` TO 'admin_user'@'localhost';
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`casos` TO 'detective_user'@'localhost';

-- RC8: Só os detetives podem registar/consultar/editar evidências de um caso
GRANT ALL PRIVILEGES ON `AgenciaDetetivesSr.Alfredo`.`evidencias` TO 'detective_user'@'localhost';

-- RC9: Só o administrador pode criar/consultar/editar/eliminar informações de qualquer detetive. Cada detetive pode realizar o mesmo, mas apenas para as suas próprias informações
GRANT ALL PRIVILEGES ON `AgenciaDetetivesSr.Alfredo`.`detetives` TO 'admin_user'@'localhost';

DELIMITER $$

CREATE PROCEDURE UpdateDetectiveInfo(IN name VARCHAR(200), IN email VARCHAR(100))
BEGIN
    DECLARE detectiveId INT;
    DECLARE currentUser VARCHAR(100);
    SET currentUser = USER();

    IF currentUser LIKE 'detective_user%@localhost' THEN
        SET detectiveId = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(currentUser, 'detective_user', -1), '@', 1) AS UNSIGNED);

        IF detectiveId > 0 THEN
            UPDATE detetives SET Nome = name, email = email WHERE idDetetive = detectiveId;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Formato inválido de ID de detetive';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Acesso não autorizado';
    END IF;
END $$

DELIMITER ;

-- Conceder permissões de execução no procedimento ao detetive
GRANT EXECUTE ON PROCEDURE `AgenciaDetetivesSr.Alfredo`.`UpdateDetectiveInfo` TO 'detective_user'@'localhost';

-- RC10: Só o administrador e os detetives podem consultar o histórico de casos solicitados por qualquer cliente
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`casos` TO 'admin_user'@'localhost';
GRANT SELECT ON `AgenciaDetetivesSr.Alfredo`.`casos` TO 'detective_user'@'localhost';

-- Flush privileges para aplicar todas as mudanças
FLUSH PRIVILEGES;
