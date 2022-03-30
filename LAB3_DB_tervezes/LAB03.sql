-- Stefán Erik Ede
-- 2022.03.30
-- INFO2_3.labor

-- 5.,
insert into Termek("idTermek","Nev","Keszlet")
values(1, "Tegla", 500);
insert into Vevo("idVevo", "Nev")
values(1, "Erik");
insert into Telephely("idTelephely", "Vevo_idVevo")
values(1, 1);
insert into Megrendeles("Termek_idTermek", "Telephely_idTelephely", "MennyiTermek")
values(1, 1, 40);

-- 6.,
update Megrendeles 
set MennyiTermek = 50
where MennyiTermek = 40;

-- 7.,
select*
from Termek
where Keszlet > 200;

-- 8.,

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Diak`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Diak` (
  `idDiak` INT NOT NULL AUTO_INCREMENT,
  `Torzsszam` INT NULL,
  `Nev` VARCHAR(45) NULL,
  `Cim` VARCHAR(45) NULL,
  `Telszam` VARCHAR(45) NULL,
  `Szuletes` DATE NULL,
  PRIMARY KEY (`idDiak`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Targy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Targy` (
  `Diak_idDiak` INT NOT NULL,
  `idTargy` INT NOT NULL,
  `Kod` VARCHAR(45) NULL,
  `Nev` VARCHAR(45) NULL,
  `Leiras` VARCHAR(45) NULL,
  PRIMARY KEY (`Diak_idDiak`, `idTargy`),
  CONSTRAINT `fk_Targy_Diak`
    FOREIGN KEY (`Diak_idDiak`)
    REFERENCES `mydb`.`Diak` (`idDiak`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Oktato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Oktato` (
  `idOktato` INT NOT NULL,
  `Nev` VARCHAR(45) NULL,
  `TanszKod` VARCHAR(45) NULL,
  `Targy_Diak_idDiak` INT NOT NULL,
  `Targy_idTargy` INT NOT NULL,
  PRIMARY KEY (`idOktato`, `Targy_Diak_idDiak`, `Targy_idTargy`),
  INDEX `fk_Oktato_Targy1_idx` (`Targy_Diak_idDiak` ASC, `Targy_idTargy` ASC) VISIBLE,
  CONSTRAINT `fk_Oktato_Targy1`
    FOREIGN KEY (`Targy_Diak_idDiak` , `Targy_idTargy`)
    REFERENCES `mydb`.`Targy` (`Diak_idDiak` , `idTargy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- 9.,
insert into Targy("idTargy", "Kod", "Nev")
values(1, "BMEVIAUAB01", "Informatika 2");
insert into Diak("Nev", "idDiak")
values("Erik", 1);
update Targy
set Diak_idDiak = 1
where Nev = "Erik";

-- 10.,
update Targy
set Nev = "Info2"
where Nev = "Informatika 2";

-- 11.,
select*
from Oktato
where Nev is not null;

-- 12.,
select*
from Oktato
where Nev like 'V%';

-- 13.,
update Targy
set Dika_idDiak = 0
where Nev = "Erik";

-- 14.,
select*
from Targy
where Leiras is null;
