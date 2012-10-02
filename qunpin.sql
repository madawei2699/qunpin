DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`fuser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`fuser` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`fuser` (
  `id` INT NOT NULL COMMENT '�û����' ,
  `name` VARCHAR(45) NULL COMMENT '�û���' ,
  `sex` INT NULL COMMENT '1-��\\n2-Ů\\n3-����' ,
  `mail` VARCHAR(45) NULL COMMENT '�ʼ�' ,
  `register_time` TIMESTAMP NULL COMMENT 'ע��ʱ��' ,
  `lock` TINYINT(1) NULL DEFAULT 0 COMMENT '0-��\\n1-��\\n��Ҫ�Ƿ�ֹע���û����ϴ��ļ���������֣�����Ա���԰�����û���ס��' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'ǰ̨�û�������ע�ᣬ�ϴ������ص�����';


-- -----------------------------------------------------
-- Table `mydb`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`book` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`book` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '����' ,
  `name` VARCHAR(45) NOT NULL COMMENT '����' ,
  `img` VARCHAR(100) NULL COMMENT '������ŷ����·��' ,
  `create_time` TIMESTAMP NULL COMMENT '����ʱ��' ,
  `delete` TINYINT(1) NULL DEFAULT 1 COMMENT '0-����ɾ��������ɾ����ص���ʷ�汾����ָ�ʽ�ĵ�����\\n1-��ɾ��' ,
  `display` TINYINT(1) NULL DEFAULT 1 COMMENT '0-����ʾ���¼�\\n1-��ʾ���ϼ�' ,
  `isbn` VARCHAR(45) NULL COMMENT 'isbn��Ϣ' ,
  `author` VARCHAR(45) NULL COMMENT '����' ,
  `type` INT NULL COMMENT '���������' ,
  `tag` INT NULL COMMENT '�������ǩ' ,
  `publish_time` TIMESTAMP NULL COMMENT '��������' ,
  `publisher` VARCHAR(45) NULL COMMENT '������' ,
  `upload` VARCHAR(45) NULL COMMENT '�������ϴ����ŵ�λ��' ,
  `review` INT NULL DEFAULT 0 COMMENT '��˽��\\n0-δ���\\n1-���ͨ��\\n2-���δͨ��\\nһ�����Ƿ��ϼܣ�ȡ������˽������ʾ��ɾ������ֵ�������ͨ��������ʾΪ�棬ɾ��Ϊ��ʱ���ñ�����ϼܣ�������ҳ���￴������������������в鵽��' ,
  `fuser_id` INT NULL COMMENT '�ϴ��߱��' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) ,
  CONSTRAINT `fk_book_fuser1`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `mydb`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '�ñ�������ŵ�����Ļ�����Ϣ';


-- -----------------------------------------------------
-- Table `mydb`.`location`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`location` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`location` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `booknum` INT NOT NULL COMMENT '��������' ,
  `location` VARCHAR(100) NULL COMMENT '����������·��' ,
  `type` INT NULL COMMENT '0-epub\\n1-mobi' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`id` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '�ñ���ÿ�������������·��';


-- -----------------------------------------------------
-- Table `mydb`.`history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`history` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`history` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '��ʷ�汾���' ,
  `booknum` INT NULL COMMENT '����' ,
  `location` VARCHAR(100) NULL COMMENT '��ʷ�汾���λ��' ,
  `create_time` TIMESTAMP NULL COMMENT '����ʱ��' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`id` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '������ŵ��������ʷ�汾��Ϣ';


-- -----------------------------------------------------
-- Table `mydb`.`buser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`buser` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`buser` (
  `id` INT NOT NULL COMMENT '�û����' ,
  `name` VARCHAR(45) NULL COMMENT '�û���' ,
  `sex` INT NULL COMMENT '1-��\\n2-Ů\\n3-����' ,
  `mail` VARCHAR(45) NULL COMMENT '�ʼ�' ,
  `register_time` TIMESTAMP NULL COMMENT 'ע��ʱ��' ,
  `type` INT NULL COMMENT '����Ա����\\n0-��������Ա��ϵͳ��ʼ��ʱ������ֻ��һ�������Թ�����������Ա��\\n1-����Ա\\n' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = '��̨�û���������Ա��¼�ġ�';


-- -----------------------------------------------------
-- Table `mydb`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`tag` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`tag` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `booknum` INT NULL COMMENT '��������' ,
  `name` VARCHAR(45) NULL COMMENT '��ǩ��' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`id` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '��ǩ��';


-- -----------------------------------------------------
-- Table `mydb`.`type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`type` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`type` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '��ǩ��' ,
  `booknum` INT NULL COMMENT '��������' ,
  `name` VARCHAR(45) NULL COMMENT '������' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`id` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '�����';


-- -----------------------------------------------------
-- Table `mydb`.`fuser_book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`fuser_book` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`fuser_book` (
  `id` INT NOT NULL ,
  `user_id` INT NOT NULL ,
  `booknum` INT NULL ,
  `d_time` TIMESTAMP NULL COMMENT '����ʱ��' ,
  `d_type` INT NULL COMMENT '���ظ�ʽ' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  INDEX `id_idx` (`user_id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id`
    FOREIGN KEY (`user_id` )
    REFERENCES `mydb`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '��¼�û����ص��������Ϣ';


-- -----------------------------------------------------
-- Table `mydb`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`log` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`log` (
  `id` INT NOT NULL ,
  `booknum` INT NULL COMMENT '��������' ,
  `fuser_id` INT NULL ,
  `type` INT NULL COMMENT '�������ͣ�\\n1-��\\n2-ɾ\\n3-�ģ�����ס�û��������ϼܣ��¼�һ���顣' ,
  `operate_time` TIMESTAMP NULL COMMENT '����ʱ�䣬��¼����Ա������鼮���û��Ĳ���ʱ�䡣' ,
  `operate_type` TINYINT(1) NULL COMMENT '��������\\n0-�û�\\n1-������\\n������¼����Ա�Ե�������û��Ĳ�����' ,
  `buser_id` INT NULL COMMENT '����Ա���' ,
  `logcol` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  INDEX `user_id_idx` (`fuser_id` ASC) ,
  INDEX `buser_id_idx` (`buser_id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fuser_id`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `mydb`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `buser_id`
    FOREIGN KEY (`buser_id` )
    REFERENCES `mydb`.`buser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '��¼��̨����Ա������־����Ҫ�Ǽ�¼����Ա���û��������Ĺ��������';


-- -----------------------------------------------------
-- Table `mydb`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`review` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`review` (
  `id` INT NOT NULL ,
  `booknum` INT NULL COMMENT '��������' ,
  `buser_id` INT NULL COMMENT '�û����' ,
  `fuser_id` INT NULL COMMENT '����Ա���' ,
  `review` INT NULL DEFAULT 0 COMMENT '0-δ���\\n1-���ͨ��\\n2-���δͨ��' ,
  `reason` VARCHAR(500) NULL COMMENT '��˲�ͨ�����ɡ�' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  INDEX `fuser_id_idx` (`fuser_id` ASC) ,
  INDEX `buser_id_idx` (`buser_id` ASC) ,
  CONSTRAINT `booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `mydb`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fuser_id`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `mydb`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `buser_id`
    FOREIGN KEY (`buser_id` )
    REFERENCES `mydb`.`buser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '��˱���������û��ϴ��鼮';



