DROP SCHEMA IF EXISTS `qp_db` ;
CREATE SCHEMA IF NOT EXISTS `qp_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_swedish_ci ;
USE `qp_db` ;

-- -----------------------------------------------------
-- Table `qp_db`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`book` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`book` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '书编号' ,
  `name` VARCHAR(45) NOT NULL COMMENT '书名' ,
  `img` VARCHAR(100) NULL COMMENT '用来存放封面的路径' ,
  `create_time` TIMESTAMP NULL COMMENT '创建时间' ,
  `delete` TINYINT(1) NULL DEFAULT 1 COMMENT '0-彻底删除，并且删除相关的历史版本与各种格式的电子书\\n1-不删除' ,
  `display` TINYINT(1) NULL DEFAULT 1 COMMENT '0-不显示，下架\\n1-显示，上架' ,
  `isbn` VARCHAR(45) NULL COMMENT 'isbn信息' ,
  `author` VARCHAR(45) NULL COMMENT '作者' ,
  `type` INT NULL COMMENT '电子书类别' ,
  `tag` INT NULL COMMENT '电子书标签' ,
  `publish_time` TIMESTAMP NULL COMMENT '出版日期' ,
  `publisher` VARCHAR(45) NULL COMMENT '出版社' ,
  `upload` VARCHAR(45) NULL COMMENT '电子书上传后存放的位置' ,
  `review` INT NULL DEFAULT 0 COMMENT '审核结果\\n0-未审核\\n1-审核通过\\n2-审核未通过\\n一本书是否上架，取决与审核结果，显示，删除三个值。当审核通过并且显示为真，删除为假时，该本书才上架，才能在页面里看到，才能在搜索结果中查到。' ,
  `fuser_id` INT NULL COMMENT '上传者编号' ,
  `lock` TINYINT(1) NULL COMMENT '是否锁定：\\n0-否\\n1-是\\n当一个电子书，我们认为它已经没有错字，排版也不需要修改，为了节省服务器资源，将它锁定，被锁定的电子书不可被编辑。' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) )
ENGINE = InnoDB
COMMENT = '该表用来存放电子书的基本信息';


-- -----------------------------------------------------
-- Table `qp_db`.`location`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`location` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`location` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `booknum` INT NOT NULL COMMENT '电子书编号' ,
  `location` VARCHAR(100) NULL COMMENT '电子书下载路径' ,
  `type` INT NULL COMMENT '0-epub\\n1-mobi' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  CONSTRAINT `l_booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `qp_db`.`book` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '该表存放每个电子书的下载路径';


-- -----------------------------------------------------
-- Table `qp_db`.`buser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`buser` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`buser` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '用户编号' ,
  `name` VARCHAR(45) NOT NULL COMMENT '用户名' ,
  `sex` INT NULL COMMENT '1-男\\n2-女\\n3-其他' ,
  `mail` VARCHAR(45) NOT NULL COMMENT '邮件' ,
  `register_time` TIMESTAMP NULL COMMENT '注册时间' ,
  `type` INT NULL COMMENT '管理员类型\\n0-超级管理员（系统初始化时建立，只有一个，可以管理其他管理员）\\n1-管理员\\n' ,
  `password` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = '后台用户表，管理人员登录的。';


-- -----------------------------------------------------
-- Table `qp_db`.`fuser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`fuser` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`fuser` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '用户编号' ,
  `name` VARCHAR(45) NOT NULL COMMENT '用户名' ,
  `sex` INT NULL COMMENT '1-男\\n2-女\\n3-其他' ,
  `mail` VARCHAR(45) NOT NULL COMMENT '邮件' ,
  `register_time` TIMESTAMP NULL COMMENT '注册时间' ,
  `lock` TINYINT(1) NULL DEFAULT 0 COMMENT '0-否\\n1-是\\n主要是防止注册用户乱上传文件，如果发现，管理员可以把这个用户锁住。' ,
  `password` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = '前台用户表，可以注册，上传，下载电子书';


-- -----------------------------------------------------
-- Table `qp_db`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`tag` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`tag` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `booknum` INT NULL COMMENT '电子书编号' ,
  `name` VARCHAR(45) NULL COMMENT '标签名' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  CONSTRAINT `tag_booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `qp_db`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '标签表';


-- -----------------------------------------------------
-- Table `qp_db`.`type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`type` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`type` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '标签号' ,
  `booknum` INT NULL COMMENT '电子书编号' ,
  `name` VARCHAR(45) NULL COMMENT '分类名' ,
  `typecol` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  CONSTRAINT `type_booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `qp_db`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '分类表';


-- -----------------------------------------------------
-- Table `qp_db`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`log` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`log` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `booknum` INT NULL COMMENT '电子书编号' ,
  `fuser_id` INT NULL ,
  `type` INT NULL COMMENT '操作类型：\\n1-增\\n2-删\\n3-改，如锁住用户，或者上架，下架一本书。' ,
  `operate_time` TIMESTAMP NULL COMMENT '操作时间，记录管理员对相关书籍和用户的操作时间。' ,
  `operate_type` TINYINT(1) NULL COMMENT '操作类型\\n0-用户\\n1-电子书\\n用来记录管理员对电子书和用户的操作。' ,
  `buser_id` INT NULL COMMENT '管理员编号' ,
  `logcol` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  INDEX `user_id_idx` (`fuser_id` ASC) ,
  INDEX `buser_id_idx` (`buser_id` ASC) ,
  CONSTRAINT `log_booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `qp_db`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `log_fuser_id`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `qp_db`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `log_buser_id`
    FOREIGN KEY (`buser_id` )
    REFERENCES `qp_db`.`buser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '记录后台管理员操作日志，主要是记录管理员对用户与电子书的管理操作。';


-- -----------------------------------------------------
-- Table `qp_db`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_db`.`review` ;

CREATE  TABLE IF NOT EXISTS `qp_db`.`review` (
  `id` INT NOT NULL ,
  `booknum` INT NULL COMMENT '电子书编号' ,
  `buser_id` INT NULL COMMENT '用户编号' ,
  `fuser_id` INT NULL COMMENT '管理员编号' ,
  `review` INT NULL DEFAULT 0 COMMENT '0-未审核\\n1-审核通过\\n2-审核未通过' ,
  `reason` VARCHAR(500) NULL COMMENT '审核不通过理由。' ,
  PRIMARY KEY (`id`) ,
  INDEX `booknum_idx` (`booknum` ASC) ,
  INDEX `fuser_id_idx` (`fuser_id` ASC) ,
  INDEX `buser_id_idx` (`buser_id` ASC) ,
  CONSTRAINT `r_booknum`
    FOREIGN KEY (`booknum` )
    REFERENCES `qp_db`.`book` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `r_fuser_id`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `qp_db`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `r_buser_id`
    FOREIGN KEY (`buser_id` )
    REFERENCES `qp_db`.`buser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '审核表，用来审核用户上传书籍';

INSERT INTO `qp_db`.`buser` (`id`, `name`, `sex`, `mail`, `register_time`, `type`, `password`) VALUES ('0', 'god', '3', 'god@qunpin.net', '2012-10-3', '0', 'qunpin');
INSERT INTO `qp_db`.`buser` (`id`, `name`, `sex`, `mail`, `register_time`, `type`, `password`) VALUES ('1', 'adm', '2', 'adm@qunpin.net', '2012-10-3', '0', 'qunpin');




