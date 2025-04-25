-- Universidade do Minho
-- Bases de Dados 2024
-- Caso de Estudo: Agência de Detetives do Sr. Alfredo

-- -----------------------------------------------------
-- Schema AgenciaDetetivesSr.Alfredo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AgenciaDetetivesSr.Alfredo` DEFAULT CHARACTER SET utf8 ;
-- drop database `AgenciaDetetivesSr.Alfredo`;
USE `AgenciaDetetivesSr.Alfredo` ;


-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`clientes` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `sexo` VARCHAR(45) NOT NULL,
  `dta_nascimento` DATE NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `nif` INT NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `cod_postal` VARCHAR(9) NOT NULL,
  `localidade` VARCHAR(250) NOT NULL,
  `concelho` VARCHAR(100) NOT NULL,
    -- Restrições sobre formato e valores de alguns parâmetros 
  CONSTRAINT `chk_nif` CHECK(LENGTH(`nif`) = 9),
  CONSTRAINT `chk_sexo` CHECK(`sexo` IN ('F','M','I')),
  CONSTRAINT `chk_cod_postal` CHECK (`cod_postal` REGEXP '^[0-9]{4}-[0-9]{3}$'),
PRIMARY KEY (`idCliente`));

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`cliente_telemoveis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`cliente_telemoveis` (
 `telemovel` VARCHAR(15) NOT NULL,
 `idCliente` INT NOT NULL,
  PRIMARY KEY (`telemovel`),
  CONSTRAINT `fk_cltelemoveis_clinte`
    FOREIGN KEY (`idCliente`)
    REFERENCES `AgenciaDetetivesSr.Alfredo`.`clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`Tipo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`tipos` (
	`idTipo` INT NOT NULL AUTO_INCREMENT,
    `Designacao` VARCHAR(45) NOT NULL,
    `descricao` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`idTipo`)
);

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`Caso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`casos` (
	`idCaso` INT NOT NULL AUTO_INCREMENT,
    `estado` CHAR(1) NOT NULL,
    `custo_agencia` INT NOT NULL,
    `desginacao` VARCHAR(100) NOT NULL,
    `descricao` TEXT NOT NULL,
    `dta_inicio` DATE NOT NULL,
    `dta_conclusao` DATE NULL,
    `Cliente` INT NOT NULL,
    `Tipo` INT NOT NULL,
    PRIMARY KEY(`idCaso`),
    -- Adicionar uma check constraint para limitar os valores de inserção na coluna estado
	-- E-Em Execucao, C-Congelado, T-Terminado
	CONSTRAINT `chk_estado` CHECK(`estado` IN ('E', 'C', 'T')),
    -- Adicionar uma check constraint para garantir que a dta_conclusao é sempre posterior à dta_inicio
	CONSTRAINT `chk_dtas` CHECK(`dta_conclusao` > `dta_inicio`),
	CONSTRAINT `fk_casos_cliente`
		FOREIGN KEY (`Cliente`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`clientes` (`idCliente`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT `fk_casos_tipo`
		FOREIGN KEY (`Tipo`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`tipos` (`idTipo`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`faturas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`faturas` (
	`idFatura` INT NOT NULL AUTO_INCREMENT,
    `dta_emissao` DATETIME NOT NULL,
    `dta_pagamento` DATETIME NULL,
    `valor` INT NOT NULL,
    `cliente` INT NOT NULL,
    `caso` INT NOT NULL,
    -- Adicionar uma check constraint para garantir que a dta_pagamento é sempre posterior à dta_emissao
	CONSTRAINT `chk_dtas_faturas` CHECK(`dta_pagamento` > `dta_emissao`),
	-- Adicionar uma check constraint para impedir a inserção de valores negativos
	CONSTRAINT `chk_valor_fatura` CHECK(`valor` >= 0),
	CONSTRAINT `fk_fatura_cliente`
		FOREIGN KEY (`cliente`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`clientes` (`idCliente`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT `fk_fatura_caso`
		FOREIGN KEY (`caso`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`casos` (`idCaso`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
    PRIMARY KEY(`idFatura`)
);

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`detetives`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`detetives`(
	`idDetetive` INT NOT NULL AUTO_INCREMENT,
    `Nome` VARCHAR(200) NOT NULL,
    `telemovel` INT NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `estado` CHAR(1) NOT NULL,
    `detetiveChefe` INT NOT NULL,
    -- Adicionar uma check constraint para limitar os valores de inserção na coluna estado
	-- A-Ativo I-Inativo
	CONSTRAINT `chk_estado_detetive` CHECK(`estado` IN ('A', 'I')),
	CONSTRAINT `fk_detetive_detetive`
		FOREIGN KEY (`detetiveChefe`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`detetives` (`idDetetive`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	PRIMARY KEY(`idDetetive`)
);

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`caso_detetive`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`caso_detetive` (
	`caso` INT NOT NULL,
    `detetive` INT NOT NULL,
    CONSTRAINT `fk_detetive_caso`
		FOREIGN KEY (`detetive`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`detetives` (`idDetetive`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT `fk_caso_detetive`
		FOREIGN KEY (`caso`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`casos` (`idCaso`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`evidencias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`evidencias`(
	`idEvidencia` INT NOT NULL AUTO_INCREMENT,
    `designacao` VARCHAR(75) NOT NULL,
    `data_coleta` DATE NOT NULL,
    `caso` INT NOT NULL,
    `detetive` INT NOT NULL,
    CONSTRAINT `fk_evidencia_detetive`
		FOREIGN KEY (`detetive`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`detetives` (`idDetetive`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT `fk_evidencia_caso`
		FOREIGN KEY (`caso`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`casos` (`idCaso`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	PRIMARY KEY (`idEvidencia`) 
);

-- -----------------------------------------------------
-- Table `AgenciaDetetivesSr.Alfredo`.`fotografias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AgenciaDetetivesSr.Alfredo`.`fotografias` (
	`fotografia` VARCHAR(75) NOT  NULL,
    `evidencia` INT NOT NULL,
	CONSTRAINT `fk_fotografia_evidencia`
		FOREIGN KEY (`evidencia`)
		REFERENCES `AgenciaDetetivesSr.Alfredo`.`evidencias` (`idEvidencia`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	PRIMARY KEY(`fotografia`)
);

ALTER TABLE clientes
ADD CONSTRAINT unq_nif UNIQUE (nif);

-- Indexacao
-- clientes
CREATE INDEX idx_email ON clientes(email);
CREATE INDEX idx_nif ON clientes(nif);

-- cliente_telemoveis
CREATE INDEX idx_idCliente ON cliente_telemoveis(idCliente);

-- casos
CREATE INDEX idx_Cliente ON casos(Cliente);
CREATE INDEX idx_Tipo ON casos(Tipo);

-- faturas table
CREATE INDEX idx_cliente ON faturas(cliente);
CREATE INDEX idx_caso ON faturas(caso);

-- detetives
CREATE INDEX idx_detetiveChefe ON detetives(detetiveChefe);

-- caso_detetive
CREATE INDEX idx_caso ON caso_detetive(caso);
CREATE INDEX idx_detetive ON caso_detetive(detetive);

-- evidencias
CREATE INDEX idx_caso ON evidencias(caso);
CREATE INDEX idx_detetive ON evidencias(detetive);

-- fotografias
CREATE INDEX idx_evidencia ON fotografias(evidencia);

