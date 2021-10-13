-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8 ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`Client` (
  `idClient` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `Cognom` VARCHAR(150) NOT NULL,
  `dni` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idClient`),
  UNIQUE INDEX `idClient_UNIQUE` (`idClient` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`botiga` (
  `idBotiga` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idBotiga`),
  UNIQUE INDEX `idBotiga_UNIQUE` (`idBotiga` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`marca` (
  `idmarca` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  UNIQUE INDEX `idmarca_UNIQUE` (`idmarca` ASC) VISIBLE,
  PRIMARY KEY (`idmarca`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`Proveïdor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`Proveïdor` (
  `idProveïdor` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CIF` VARCHAR(45) NOT NULL,
  `nomcomercial` VARCHAR(45) NOT NULL,
  `nomFiscal` VARCHAR(75) NOT NULL,
  PRIMARY KEY (`idProveïdor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`compres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`compres` (
  `idcompres` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fk_botiga` INT UNSIGNED NOT NULL,
  `fk_article` INT UNSIGNED NOT NULL,
  `fk_proveidor` INT UNSIGNED NOT NULL,
  `fk_marca` INT UNSIGNED NOT NULL,
  `descompte` FLOAT NOT NULL,
  `quantitat` INT NOT NULL,
  PRIMARY KEY (`idcompres`),
  UNIQUE INDEX `idcompres_UNIQUE` (`idcompres` ASC) VISIBLE,
  UNIQUE INDEX `compres_botiga_prov_marca` (`fk_botiga` ASC, `fk_proveidor` ASC, `fk_marca` ASC) INVISIBLE,
  INDEX `fk_compres_article_idx` (`fk_article` ASC) VISIBLE,
  INDEX `fk_compres_marca1_idx` (`fk_marca` ASC) VISIBLE,
  CONSTRAINT `fk_compres_Botiga1`
    FOREIGN KEY (`fk_botiga`)
    REFERENCES `optica`.`botiga` (`idBotiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compres_Proveïdor1`
    FOREIGN KEY (`fk_proveidor`)
    REFERENCES `optica`.`Proveïdor` (`idProveïdor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compres_article`
    FOREIGN KEY (`fk_article`)
    REFERENCES `optica`.`article` (`idarticle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_compres_marca1`
    FOREIGN KEY (`fk_marca`)
    REFERENCES `optica`.`marca` (`idmarca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`article`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`article` (
  `idarticle` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `codi` VARCHAR(45) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(45) NOT NULL,
  `sku` VARCHAR(45) NOT NULL,
  `fk_marca` INT UNSIGNED NOT NULL,
  `pvp` FLOAT NOT NULL,
  UNIQUE INDEX `idarticle_UNIQUE` (`idarticle` ASC) VISIBLE,
  INDEX `fk_article_marca1_idx` (`fk_marca` ASC) VISIBLE,
  PRIMARY KEY (`idarticle`),
  CONSTRAINT `fk_article_marca1`
    FOREIGN KEY (`fk_marca`)
    REFERENCES `optica`.`marca` (`idmarca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_article_compres1`
    FOREIGN KEY (`idarticle`)
    REFERENCES `optica`.`compres` (`fk_article`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`magatzem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`magatzem` (
  `idmagatzem` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fk_botiga` INT UNSIGNED NOT NULL,
  `fk_article` INT UNSIGNED NOT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idmagatzem`),
  UNIQUE INDEX `idmagatzem_UNIQUE` (`idmagatzem` ASC) VISIBLE,
  INDEX `fk_magatzem_Botiga1_idx` (`fk_botiga` ASC) INVISIBLE,
  INDEX `fk_magatzem_article1_idx` (`fk_article` ASC) VISIBLE,
  CONSTRAINT `fk_magatzem_Botiga1`
    FOREIGN KEY (`fk_botiga`)
    REFERENCES `optica`.`botiga` (`idBotiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_magatzem_article1`
    FOREIGN KEY (`fk_article`)
    REFERENCES `optica`.`article` (`idarticle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`vendes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`vendes` (
  `idvendes` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fk_botiga` INT UNSIGNED NOT NULL,
  `fk_magatzem` INT UNSIGNED NOT NULL,
  `fk_article` INT UNSIGNED NOT NULL,
  `fk_client` INT UNSIGNED NOT NULL,
  `data_venda` DATE NOT NULL,
  `quantitat` INT NOT NULL,
  PRIMARY KEY (`idvendes`),
  UNIQUE INDEX `idvendes_UNIQUE` (`idvendes` ASC) VISIBLE,
  INDEX `fk_vendes_magatzem1_idx` (`fk_magatzem` ASC) VISIBLE,
  INDEX `fk_vendes_magatzem2_idx` (`fk_article` ASC) VISIBLE,
  INDEX `fk_vendes_magatzem3_idx` (`fk_botiga` ASC) VISIBLE,
  CONSTRAINT `fk_vendes_Client1`
    FOREIGN KEY (`fk_client`)
    REFERENCES `optica`.`Client` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendes_magatzem1`
    FOREIGN KEY (`fk_magatzem`)
    REFERENCES `optica`.`magatzem` (`idmagatzem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendes_magatzem2`
    FOREIGN KEY (`fk_article`)
    REFERENCES `optica`.`magatzem` (`fk_article`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vendes_magatzem3`
    FOREIGN KEY (`fk_botiga`)
    REFERENCES `optica`.`magatzem` (`fk_botiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`empleat` (
  `idempleat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`idempleat`),
  UNIQUE INDEX `idempleat_UNIQUE` (`idempleat` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`empleat_x_botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`empleat_x_botiga` (
  `idempleat_x_botiga` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fk_botiga` INT UNSIGNED NOT NULL,
  `fk_empleat` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idempleat_x_botiga`),
  INDEX `fk_empleat_x_botiga_Botiga1_idx` (`fk_botiga` ASC) VISIBLE,
  INDEX `fk_empleat_x_botiga_empleat1_idx` (`fk_empleat` ASC) VISIBLE,
  UNIQUE INDEX `idmarca_x_botiga_UNIQUE` (`idempleat_x_botiga` ASC) VISIBLE,
  CONSTRAINT `fk_empleat_x_botiga_Botiga1`
    FOREIGN KEY (`fk_botiga`)
    REFERENCES `optica`.`botiga` (`idBotiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_empleat_x_botiga_empleat1`
    FOREIGN KEY (`fk_empleat`)
    REFERENCES `optica`.`empleat` (`idempleat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`empleat_has_vendes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`empleat_has_vendes` (
  `empleat_idempleat` INT UNSIGNED NOT NULL,
  `vendes_idvendes` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`empleat_idempleat`, `vendes_idvendes`),
  INDEX `fk_empleat_has_vendes_vendes1_idx` (`vendes_idvendes` ASC) VISIBLE,
  INDEX `fk_empleat_has_vendes_empleat1_idx` (`empleat_idempleat` ASC) VISIBLE,
  CONSTRAINT `fk_empleat_has_vendes_empleat1`
    FOREIGN KEY (`empleat_idempleat`)
    REFERENCES `optica`.`empleat` (`idempleat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_empleat_has_vendes_vendes1`
    FOREIGN KEY (`vendes_idvendes`)
    REFERENCES `optica`.`vendes` (`idvendes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`montura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`montura` (
  `idmontura` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(45) NULL,
  PRIMARY KEY (`idmontura`),
  UNIQUE INDEX `idmontura_UNIQUE` (`idmontura` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`article_detall`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`article_detall` (
  `fk_idarticle` INT UNSIGNED NOT NULL,
  `vidreL` VARCHAR(45) NOT NULL,
  `vidreR` VARCHAR(45) NOT NULL,
  `fk_montura` INT UNSIGNED NOT NULL,
  `vidreLColor` VARCHAR(45) NOT NULL,
  `vidreRColor` VARCHAR(45) NOT NULL,
  `monturaColor` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`fk_idarticle`),
  UNIQUE INDEX `fk_idarticle_UNIQUE` (`fk_idarticle` ASC) VISIBLE,
  INDEX `fk_article_detall_montura1_idx` (`fk_montura` ASC) VISIBLE,
  CONSTRAINT `fk_article_detall_article1`
    FOREIGN KEY (`fk_idarticle`)
    REFERENCES `optica`.`article` (`idarticle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_article_detall_montura1`
    FOREIGN KEY (`fk_montura`)
    REFERENCES `optica`.`montura` (`idmontura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
