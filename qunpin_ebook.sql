SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `qp_ebook_db`.`ebook`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_ebook_db`.`ebook` ;

CREATE  TABLE IF NOT EXISTS `qp_ebook_db`.`ebook` (
  `ebook_id` INT NOT NULL AUTO_INCREMENT COMMENT '书编号' ,
  `title` VARCHAR(45) NOT NULL COMMENT ' 标题' ,
  `subtitle` VARCHAR(45) NULL COMMENT '副标题' ,
  `origin_title` VARCHAR(45) NULL COMMENT '原作名' ,
  `isbn10` VARCHAR(45) NULL COMMENT 'isbn10' ,
  `author` VARCHAR(100) NULL COMMENT '作者' ,
  `translator` VARCHAR(100) NULL COMMENT '译者' ,
  `price` DOUBLE NULL COMMENT '定价' ,
  `publisher` VARCHAR(45) NULL COMMENT '出版社' ,
  `pubdate` DATE NULL COMMENT '出版日期' ,
  `binding` VARCHAR(45) NULL COMMENT '装帧\\n1-平装\\n2-精装\\n3-Paperback\\n4-Hardcover\\n5-其他' ,
  `pages` INT NULL COMMENT '页数' ,
  `summary` TEXT NULL COMMENT '内容简介' ,
  `author_intro` TEXT NULL COMMENT '作者简介' ,
  `isbn13` VARCHAR(45) NULL COMMENT 'isbn13' ,
  `url` VARCHAR(100) NULL COMMENT 'url\\napi的url' ,
  `alt_title` VARCHAR(45) NULL COMMENT '书名，当图片不能加载时显示，对搜索引擎友好。' ,
  `images` VARCHAR(200) NULL COMMENT '书封面的三种格式的URL\\nsmall: \\\"http://img1.douban.com/spic/s1001902.jpg\\\",\\nlarge: \\\"http://img1.douban.com/lpic/s1001902.jpg\\\",\\nmedium: \\\"http://img1.douban.com/mpic/s1001902.jpg\\\"' ,
  `alt` VARCHAR(100) NULL COMMENT '书籍的访问URL' ,
  `image` VARCHAR(100) NULL COMMENT '书籍封面URL' ,
  `rating` FLOAT NULL COMMENT '书评分\\n10分制\\nmax: 10,\\nnumRaters: xxx,\\naverage: \\\"x.x\\\",\\nmin: 0\\n' ,
  `tags` VARCHAR(500) NULL COMMENT '书标签' ,
  `index` TEXT NULL COMMENT '目录\\n主要是用来在图书信息也显示目录。' ,
  PRIMARY KEY (`ebook_id`) ,
  UNIQUE INDEX `id_UNIQUE` (`ebook_id` ASC) )
ENGINE = InnoDB
COMMENT = '该表用来存放电子书的基本信息';


-- -----------------------------------------------------
-- Table `qp_ebook_db`.`tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_ebook_db`.`tags` ;

CREATE  TABLE IF NOT EXISTS `qp_ebook_db`.`tags` (
  `tags_id` INT NOT NULL ,
  `count` INT NULL ,
  `name` VARCHAR(45) NULL ,
  `ebook_ebook_id` INT NOT NULL ,
  PRIMARY KEY (`tags_id`, `ebook_ebook_id`) ,
  INDEX `fk_tags_ebook1_idx` (`ebook_ebook_id` ASC) ,
  CONSTRAINT `fk_tags_ebook1`
    FOREIGN KEY (`ebook_ebook_id` )
    REFERENCES `qp_ebook_db`.`ebook` (`ebook_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qp_ebook_db`.`fuser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_ebook_db`.`fuser` ;

CREATE  TABLE IF NOT EXISTS `qp_ebook_db`.`fuser` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '用户编号' ,
  `name` VARCHAR(45) NOT NULL COMMENT '用户名' ,
  `sex` INT NULL COMMENT '1-男\\n2-女\\n3-其他' ,
  `mail` VARCHAR(45) NOT NULL COMMENT '邮件' ,
  `register_time` TIMESTAMP NULL COMMENT '注册时间' ,
  `lock` TINYINT(1) NULL DEFAULT 0 COMMENT '0-否\\n1-是\\n主要是防止注册用户乱上传文件，如果发现，管理员可以把这个用户锁住。' ,
  `password` VARCHAR(45) NOT NULL ,
  `salt` VARCHAR(45) NULL COMMENT '随机数，用来增强安全' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = '前台用户表，可以注册，上传，下载电子书';


-- -----------------------------------------------------
-- Table `qp_ebook_db`.`rating`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_ebook_db`.`rating` ;

CREATE  TABLE IF NOT EXISTS `qp_ebook_db`.`rating` (
  `rating_id` INT NOT NULL ,
  `max` INT NULL DEFAULT 10 ,
  `numRaters` INT NULL ,
  `average` INT NULL ,
  `min` INT NULL DEFAULT 0 ,
  `ebook_ebook_id` INT NOT NULL ,
  `fuser_id` INT NOT NULL ,
  PRIMARY KEY (`rating_id`, `ebook_ebook_id`, `fuser_id`) ,
  INDEX `fk_rating_ebook1_idx` (`ebook_ebook_id` ASC) ,
  INDEX `fk_rating_fuser1_idx` (`fuser_id` ASC) ,
  CONSTRAINT `fk_rating_ebook1`
    FOREIGN KEY (`ebook_ebook_id` )
    REFERENCES `qp_ebook_db`.`ebook` (`ebook_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rating_fuser1`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `qp_ebook_db`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qp_ebook_db`.`ebook_has_fuser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_ebook_db`.`ebook_has_fuser` ;

CREATE  TABLE IF NOT EXISTS `qp_ebook_db`.`ebook_has_fuser` (
  `ebook_ebook_id` INT NOT NULL ,
  `fuser_id` INT NOT NULL ,
  `read_type` INT NULL COMMENT '1-想读\\n2-在读\\n3-读过\\n4-推荐' ,
  PRIMARY KEY (`ebook_ebook_id`, `fuser_id`) ,
  INDEX `fk_ebook_has_fuser_fuser1_idx` (`fuser_id` ASC) ,
  INDEX `fk_ebook_has_fuser_ebook1_idx` (`ebook_ebook_id` ASC) ,
  CONSTRAINT `fk_ebook_has_fuser_ebook1`
    FOREIGN KEY (`ebook_ebook_id` )
    REFERENCES `qp_ebook_db`.`ebook` (`ebook_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ebook_has_fuser_fuser1`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `qp_ebook_db`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `qp_ebook_db`.`tags_has_fuser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `qp_ebook_db`.`tags_has_fuser` ;

CREATE  TABLE IF NOT EXISTS `qp_ebook_db`.`tags_has_fuser` (
  `tags_tags_id` INT NOT NULL ,
  `tags_ebook_ebook_id` INT NOT NULL ,
  `fuser_id` INT NOT NULL ,
  PRIMARY KEY (`tags_tags_id`, `tags_ebook_ebook_id`, `fuser_id`) ,
  INDEX `fk_tags_has_fuser_fuser1_idx` (`fuser_id` ASC) ,
  INDEX `fk_tags_has_fuser_tags1_idx` (`tags_tags_id` ASC, `tags_ebook_ebook_id` ASC) ,
  CONSTRAINT `fk_tags_has_fuser_tags1`
    FOREIGN KEY (`tags_tags_id` , `tags_ebook_ebook_id` )
    REFERENCES `qp_ebook_db`.`tags` (`tags_id` , `ebook_ebook_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tags_has_fuser_fuser1`
    FOREIGN KEY (`fuser_id` )
    REFERENCES `qp_ebook_db`.`fuser` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
