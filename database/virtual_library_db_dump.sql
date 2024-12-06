CREATE DATABASE IF NOT EXISTS `virtual_library_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `virtual_library_db`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: virtual_library_db
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `author` (
  `author_id` int NOT NULL AUTO_INCREMENT,
  `author_name` varchar(128) NOT NULL,
  `email_address` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`author_id`),
  UNIQUE KEY `author_ak_name` (`author_name`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'Alexander McCall Smith','s1khyo890@example.com'),(2,'Alice Sebold','gm5j2f762mg@example.com'),(3,'Andrea Levy','u8qfwq7x@outlook.com'),(4,'Arthur Golden','r5f0dph2bwr@yahoo.com'),(5,'Audrey Niffenegger','t75sfwb4krs@hotmail.com'),(6,'Barack Obama','bzvag1mvz6o@example.com'),(7,'Ben Schott','vxhp3k7@example.com'),(8,'Bill Bryson','haux42@outlook.com'),(9,'Conn Iggulden and Hal Iggulden\n','ejqibyfrv@yahoo.com'),(10,'Dan Brown','k7lh7sml02@gmail.com'),(11,'Dave Pelzer','hzlvn@example.com'),(12,'Dawn French','vjq3vd@hotmail.com'),(13,'Delia Smith','7p3wdaqmah@outlook.com'),(14,'Eric Carle','ce0yrzeh@yahoo.com'),(15,'Frank McCourt','x6y721z1s@hotmail.com'),(16,'Gillian McKeith','jlq8rd1idopt@hotmail.com'),(17,'Harper Lee','k1cg88a@outlook.com'),(18,'Helen Fielding','50tu7l@example.com'),(19,'Ian McEwan','b08yy3@yahoo.com'),(20,'J. K. Rowling','iphg0@example.com'),(21,'J.D. Salinger','u62tze@yahoo.com'),(22,'Jamie Oliver','tq1v6cta3@example.com'),(23,'Jed Rubenfeld','42aglnb4t0@example.com'),(24,'Jeremy Clarkson','17pb48u4bo@example.com'),(25,'Joanne Harris','t2we7l9kd@yahoo.com'),(26,'John Boyne','pyig8u1@example.com'),(27,'John Grisham','kqdhrau34@yahoo.com'),(28,'Julia Donaldson','rslno9wp@gmail.com'),(29,'Kate Morton','486k96slhl3@example.com'),(30,'Kate Mosse','g2un5fsll8eb@gmail.com'),(31,'Khaled Hosseini','u1jpvg@outlook.com'),(32,'Kim Edwards','22h9ec5s77o@outlook.com'),(33,'Lauren Weisberger','hyh19et8@example.com'),(34,'Linwood Barclay','dlr1kffavg5@gmail.com'),(35,'Louis De Bernieres','kwieg7pt2e1g@example.com'),(36,'Lynne Truss','5j6rvw6k36@outlook.com'),(37,'Marian Keyes','ijosh@gmail.com'),(38,'Marina Lewycka','exxx5d3gjke@example.com'),(39,'Mark Haddon','qfymd5h8@outlook.com'),(40,'Markus Zusak','nlo0pz4778@hotmail.com'),(41,'Michael Moore','65i44@example.com'),(42,'Monica Ali','rxg5lntjord5@yahoo.com'),(43,'Nigella Lawson','2mscuv0dlcz@gmail.com'),(44,'Pamela Stephenson','abq8dqxr3o6@hotmail.com'),(45,'Paul McKenna','qy1tno6@yahoo.com'),(46,'Paul O\'Grady','ocr3k5jf@yahoo.com'),(47,'Paulo Coelho','jwvrwun3s6oh@example.com'),(48,'Peter Kay','v92jly18i@example.com'),(49,'Philip Pullman','djbrwtpm8s@hotmail.com'),(50,'Robert C. Atkins','db4twvgyv@gmail.com'),(51,'Sebastian Faulks','l0x6m@outlook.com'),(52,'Sharon Osbourne','1x5yak7uz@example.com'),(53,'Sophie Kinsella','qfah8@hotmail.com'),(54,'Stephenie Meyer','44dfdi@example.com'),(55,'Stieg Larsson','id9m08@yahoo.com'),(56,'Tony Parsons','1qaki0f@gmail.com'),(57,'Victoria Hislop','5nm9dqyf3p@hotmail.com'),(58,'Yann Martel','egp928yyma@gmail.com'),(59,'Zadie Smith','4oxrvul@example.com');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `book_id` int NOT NULL AUTO_INCREMENT,
  `book_title` varchar(256) NOT NULL,
  `author_id` int DEFAULT NULL,
  `publisher_id` int NOT NULL,
  `release_date` date NOT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `book_ak` (`book_title`,`release_date`),
  KEY `book_fk_author` (`author_id`),
  KEY `book_fk_publisher` (`publisher_id`),
  CONSTRAINT `book_fk_author` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_fk_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'The Da Vinci Code',10,1,'2004-03-01'),(2,'Harry Potter and the Philosopher\'s Stone',20,2,'1997-06-26'),(3,'Harry Potter and the Chamber of Secrets',20,2,'1999-04-01'),(4,'Angels and Demons',10,1,'2003-07-01'),(5,'Harry Potter and the Order of the Phoenix',20,2,'2003-06-21'),(6,'Harry Potter and the Half-blood Prince: Children\'s Edition',20,2,'2005-07-16'),(7,'Harry Potter and the Deathly Hallows',20,2,'2007-07-21'),(8,'Harry Potter and the Prisoner of Azkaban',20,2,'2000-04-01'),(9,'Twilight',54,3,'2007-03-22'),(10,'Harry Potter and the Goblet of Fire',20,2,'2001-07-06'),(11,'Deception Point',10,1,'2004-05-01'),(12,'New Moon',54,3,'2007-09-06'),(13,'The Lovely Bones',2,4,'2009-12-04'),(14,'Digital Fortress',10,1,'2004-03-05'),(15,'The Curious Incident of the Dog in the Night-time',39,5,'2004-04-01'),(16,'Eclipse',54,3,'2008-07-03'),(17,'The Girl with the Dragon Tattoo',55,6,'2008-07-24'),(18,'The Kite Runner',31,2,'2004-06-07'),(19,'The Time Traveler\'s Wife',5,5,'2004-05-29'),(20,'The World According to Clarkson',24,7,'2005-05-26'),(21,'Atonement',19,5,'2002-05-02'),(22,'The Lost Symbol',10,1,'2009-09-15'),(23,'A Short History of Nearly Everything',8,1,'2004-06-01'),(24,'Breaking Dawn',54,3,'2008-08-04'),(25,'Harry Potter and the Goblet of Fire',20,2,'2000-07-08'),(26,'The Girl Who Played with Fire',55,6,'2010-07-29'),(27,'A Child Called It',11,8,'2001-01-04'),(28,'No.1 Ladies\' Detective Agency',1,3,'2003-06-05'),(29,'You are What You Eat:The Plan That Will Change Your Life',16,7,'2004-06-17'),(30,'Man and Boy',56,9,'2000-03-06'),(31,'Birdsong',51,5,'1994-07-18'),(32,'Labyrinth',30,8,'2006-01-11'),(33,'The Island',57,10,'2006-04-10'),(34,'Life of Pi',58,11,'2003-05-17'),(35,'Dr. Atkins\' New Diet Revolution',50,5,'2003-01-02'),(36,'The Tales of Beedle the Bard',20,2,'2008-12-04'),(37,'Captain Corelli\'s Mandolin',35,5,'1995-06-01'),(38,'Delia\'s How to Cook: Book One',13,5,'1998-10-12'),(39,'The Gruffalo',28,4,'2009-03-06'),(40,'Eats, Shoots and Leaves: The Zero Tolerance Approach to Punctuation',36,12,'2003-11-06'),(41,'The Interpretation of Murder',23,10,'2007-01-15'),(42,'The Girl Who Kicked the Hornets\' Nest',55,6,'2010-04-01'),(43,'Bridget Jones: The Edge of Reason',18,4,'2000-06-15'),(44,'A Short History of Tractors in Ukrainian',38,7,'2006-03-02'),(45,'The Alchemist: A Fable About Following Your Dream',47,9,'1999-09-06'),(46,'Notes from a Small Island',8,1,'1996-08-01'),(47,'The Boy in the Striped Pyjamas',26,1,'2007-02-01'),(48,'Stupid White Men:...and Other Sorry Excuses for the State of the Nation',41,7,'2002-10-03'),(49,'Jamie\'s 30-minute Meals',22,7,'2010-09-30'),(50,'The Broker',27,5,'2005-08-27'),(51,'Bridget Jones\'s Diary: A Novel',18,4,'1997-06-20'),(52,'The Very Hungry Caterpillar',14,7,'1994-09-29'),(53,'A Thousand Splendid Suns',31,2,'2007-05-22'),(54,'The Sound of Laughter',48,5,'2006-10-05'),(55,'Jamie\'s Italy',22,7,'2005-10-03'),(56,'Small Island',3,10,'2004-09-13'),(57,'The Memory Keeper\'s Daughter',32,7,'2007-04-26'),(58,'Billy Connolly',44,9,'2002-07-08'),(59,'The House at Riverton',29,4,'2007-06-15'),(60,'Harry Potter and the Order of the Phoenix',20,2,'2004-07-10'),(61,'Nigella Express',43,5,'2007-09-06'),(62,'Memoirs of a Geisha',4,5,'1998-06-04'),(63,'Delia\'s How to Cook: Book Two',13,5,'1999-12-09'),(64,'Jamie\'s Ministry of Food: Anyone Can Learn to Cook in 24 Hours',22,7,'2008-10-03'),(65,'Jamie at Home: Cook Your Way to the Good Life',22,7,'2007-09-06'),(66,'White Teeth',59,7,'2001-01-25'),(67,'The Devil Wears Prada',33,9,'2003-10-06'),(68,'At My Mother\'s Knee ...:and Other Low Joints',46,1,'2008-09-24'),(69,'No Time for Goodbye',34,8,'2008-06-12'),(70,'Chocolat',25,1,'2000-03-02'),(71,'The Return of the Naked Chef',22,7,'2000-03-30'),(72,'Angela\'s Ashes: A Memoir of a Childhood',15,9,'1997-05-06'),(73,'Schott\'s Original Miscellany',7,2,'2002-11-04'),(74,'Dreams from My Father: A Story of Race and Inheritance',6,11,'2008-06-05'),(75,'The Dangerous Book for Boys',9,9,'2006-06-05'),(76,'To Kill a Mockingbird',17,5,'1989-10-05'),(77,'Harry Potter and the Half-blood Prince',20,2,'2005-07-16'),(78,'The Summons',27,5,'2002-09-28'),(79,'The Lost Symbol',10,1,'2010-07-22'),(80,'The Catcher in the Rye',21,7,'1994-08-04'),(81,'I Can Make You Thin',45,1,'2005-01-17'),(82,'Happy Days with the Naked Chef',22,7,'2001-09-03'),(83,'Brick Lane',42,1,'2004-05-01'),(84,'Anybody Out There?',37,7,'2007-02-08'),(85,'The Undomestic Goddess',53,1,'2006-01-02'),(86,'The Book Thief',40,1,'2008-01-01'),(87,'I Know You Got Soul',24,7,'2006-05-25'),(88,'Sharon Osbourne Extreme: My Autobiography',52,3,'2005-10-03'),(89,'Can You Keep a Secret?',53,1,'2003-03-17'),(90,'Down Under',8,1,'2001-08-06'),(91,'A Spot of Bother',39,5,'2007-06-07'),(92,'Dear Fatty',12,5,'2008-10-09'),(93,'Northern Lights: His Dark Materials',49,13,'1998-10-23'),(94,'The Subtle Knife',49,13,'1998-10-16'),(95,'The Amber Spyglass',49,13,'2001-09-14');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre`
--

DROP TABLE IF EXISTS `book_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genre` (
  `book_id` int NOT NULL,
  `genre_name` varchar(64) NOT NULL,
  PRIMARY KEY (`book_id`,`genre_name`),
  KEY `book_genre_fk_genre` (`genre_name`),
  CONSTRAINT `book_genre_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_genre_fk_genre` FOREIGN KEY (`genre_name`) REFERENCES `genre` (`genre_name`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genre`
--

LOCK TABLES `book_genre` WRITE;
/*!40000 ALTER TABLE `book_genre` DISABLE KEYS */;
INSERT INTO `book_genre` VALUES (27,'Autobiography General'),(54,'Autobiography General'),(72,'Autobiography General'),(74,'Autobiography Historical'),(68,'Autobiography The Arts'),(88,'Autobiography The Arts'),(92,'Autobiography The Arts'),(58,'Biography The Arts'),(2,'Children\'s Fiction'),(3,'Children\'s Fiction'),(5,'Children\'s Fiction'),(6,'Children\'s Fiction'),(7,'Children\'s Fiction'),(8,'Children\'s Fiction'),(10,'Children\'s Fiction'),(36,'Children\'s Fiction'),(1,'Crime'),(4,'Crime'),(11,'Crime'),(14,'Crime'),(17,'Crime'),(22,'Crime'),(26,'Crime'),(28,'Crime'),(41,'Crime'),(42,'Crime'),(50,'Crime'),(69,'Crime'),(78,'Crime'),(48,'Current Affairs and Issues'),(29,'Fitness and Diet'),(35,'Fitness and Diet'),(81,'Fitness and Diet'),(38,'Food and Drink General'),(49,'Food and Drink General'),(61,'Food and Drink General'),(63,'Food and Drink General'),(64,'Food and Drink General'),(65,'Food and Drink General'),(71,'Food and Drink General'),(82,'Food and Drink General'),(13,'General and Literary Fiction'),(15,'General and Literary Fiction'),(18,'General and Literary Fiction'),(19,'General and Literary Fiction'),(21,'General and Literary Fiction'),(30,'General and Literary Fiction'),(31,'General and Literary Fiction'),(32,'General and Literary Fiction'),(33,'General and Literary Fiction'),(34,'General and Literary Fiction'),(37,'General and Literary Fiction'),(43,'General and Literary Fiction'),(44,'General and Literary Fiction'),(45,'General and Literary Fiction'),(51,'General and Literary Fiction'),(53,'General and Literary Fiction'),(56,'General and Literary Fiction'),(57,'General and Literary Fiction'),(59,'General and Literary Fiction'),(62,'General and Literary Fiction'),(66,'General and Literary Fiction'),(67,'General and Literary Fiction'),(70,'General and Literary Fiction'),(76,'General and Literary Fiction'),(80,'General and Literary Fiction'),(83,'General and Literary Fiction'),(84,'General and Literary Fiction'),(85,'General and Literary Fiction'),(86,'General and Literary Fiction'),(89,'General and Literary Fiction'),(91,'General and Literary Fiction'),(75,'Hobbies'),(20,'Humour Collections and General'),(55,'National and Regional Cuisine'),(75,'Pastimes and Indoor'),(39,'Picture Books'),(23,'Popular Science'),(52,'Pre school and Early Learning'),(7,'Science Fiction and Fantasy'),(77,'Science Fiction and Fantasy'),(1,'Thriller and Adventure'),(4,'Thriller and Adventure'),(11,'Thriller and Adventure'),(14,'Thriller and Adventure'),(17,'Thriller and Adventure'),(22,'Thriller and Adventure'),(26,'Thriller and Adventure'),(28,'Thriller and Adventure'),(41,'Thriller and Adventure'),(42,'Thriller and Adventure'),(50,'Thriller and Adventure'),(69,'Thriller and Adventure'),(78,'Thriller and Adventure'),(87,'Transport General'),(46,'Travel Writing'),(90,'Travel Writing'),(73,'Trivia and Quiz Books'),(40,'Usage and Writing Guides'),(9,'Young Adult Fiction'),(12,'Young Adult Fiction'),(16,'Young Adult Fiction'),(24,'Young Adult Fiction'),(47,'Young Adult Fiction'),(93,'Young Adult Fiction'),(94,'Young Adult Fiction'),(95,'Young Adult Fiction');
/*!40000 ALTER TABLE `book_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_list`
--

DROP TABLE IF EXISTS `book_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_list` (
  `list_name` varchar(64) NOT NULL,
  `user_name` varchar(64) NOT NULL,
  PRIMARY KEY (`list_name`,`user_name`),
  KEY `book_list_fk_user` (`user_name`),
  CONSTRAINT `book_list_fk_user` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_list`
--

LOCK TABLES `book_list` WRITE;
/*!40000 ALTER TABLE `book_list` DISABLE KEYS */;
INSERT INTO `book_list` VALUES ('jack\'s first book list','jack'),('sai\'s first book list','sai'),('sebastian\'s first book list','sebastian');
/*!40000 ALTER TABLE `book_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_list_book`
--

DROP TABLE IF EXISTS `book_list_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_list_book` (
  `book_list_name` varchar(64) NOT NULL,
  `user_name` varchar(64) NOT NULL,
  `book_id` int NOT NULL,
  PRIMARY KEY (`book_list_name`,`user_name`,`book_id`),
  KEY `book_list_book_fk_book` (`book_id`),
  CONSTRAINT `book_list_book_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_list_book_fk_book_list` FOREIGN KEY (`book_list_name`, `user_name`) REFERENCES `book_list` (`list_name`, `user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_list_book`
--

LOCK TABLES `book_list_book` WRITE;
/*!40000 ALTER TABLE `book_list_book` DISABLE KEYS */;
INSERT INTO `book_list_book` VALUES ('jack\'s first book list','jack',1),('jack\'s first book list','jack',2),('jack\'s first book list','jack',3),('jack\'s first book list','jack',4),('jack\'s first book list','jack',5),('jack\'s first book list','jack',6),('jack\'s first book list','jack',7),('jack\'s first book list','jack',8),('jack\'s first book list','jack',9),('jack\'s first book list','jack',10),('sai\'s first book list','sai',11),('sai\'s first book list','sai',12),('sai\'s first book list','sai',13),('sai\'s first book list','sai',14),('sai\'s first book list','sai',15),('sai\'s first book list','sai',16),('sai\'s first book list','sai',17),('sai\'s first book list','sai',18),('sai\'s first book list','sai',19),('sai\'s first book list','sai',20),('sebastian\'s first book list','sebastian',21),('sebastian\'s first book list','sebastian',22),('sebastian\'s first book list','sebastian',23),('sebastian\'s first book list','sebastian',24),('sebastian\'s first book list','sebastian',25),('sebastian\'s first book list','sebastian',26),('sebastian\'s first book list','sebastian',27),('sebastian\'s first book list','sebastian',28),('sebastian\'s first book list','sebastian',29),('sebastian\'s first book list','sebastian',30);
/*!40000 ALTER TABLE `book_list_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_rating`
--

DROP TABLE IF EXISTS `book_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_rating` (
  `user_name` varchar(64) NOT NULL,
  `book_id` int NOT NULL,
  `text` text,
  `score` int NOT NULL,
  PRIMARY KEY (`user_name`,`book_id`),
  KEY `user_book_rating_fk_book` (`book_id`),
  CONSTRAINT `user_book_rating_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_book_rating_fk_user` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `score_ck` CHECK ((`score` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_rating`
--

LOCK TABLES `book_rating` WRITE;
/*!40000 ALTER TABLE `book_rating` DISABLE KEYS */;
INSERT INTO `book_rating` VALUES ('jack',1,'I thought that this book was very good',5),('jack',2,'I did not think thay this book was very good',1);
/*!40000 ALTER TABLE `book_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_series`
--

DROP TABLE IF EXISTS `book_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_series` (
  `book_id` int NOT NULL,
  `series_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`series_id`),
  KEY `book_series_fk_series` (`series_id`),
  CONSTRAINT `book_series_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_series_fk_series` FOREIGN KEY (`series_id`) REFERENCES `series` (`series_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_series`
--

LOCK TABLES `book_series` WRITE;
/*!40000 ALTER TABLE `book_series` DISABLE KEYS */;
INSERT INTO `book_series` VALUES (43,1),(51,1),(38,2),(63,2),(2,3),(3,3),(5,3),(6,3),(8,3),(10,3),(77,3),(89,4),(94,4),(49,5),(55,5),(64,5),(65,5),(17,6),(26,6),(42,6),(1,7),(4,7),(71,8),(82,8),(9,9),(12,9),(16,9),(24,9);
/*!40000 ALTER TABLE `book_series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genre_name` varchar(64) NOT NULL,
  PRIMARY KEY (`genre_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES ('Adventure'),('Anthology'),('Art and Photography'),('Autobiography'),('Autobiography General'),('Autobiography Historical'),('Autobiography The Arts'),('Biography'),('Biography The Arts'),('Business'),('Children\'s Fiction'),('Children\'s Literature'),('Classics'),('Contemporary'),('Cookbooks'),('Crime'),('Current Affairs and Issues'),('Drama'),('Dystopian'),('Encyclopedias and General Reference'),('Essays'),('Family Saga'),('Fantasy'),('Fitness and Diet'),('Food and Drink General'),('General and Literary Fiction'),('Gothic'),('Graphic Novels'),('Health and Wellness'),('Historical Comedy'),('Historical Fiction'),('History'),('Hobbies'),('Horror'),('Humor'),('Humour Collections and General'),('Magical Realism'),('Memoir'),('Memoirs'),('Mystery'),('Mythology'),('National and Regional Cuisine'),('Paranormal'),('Pastimes and Indoor'),('Philosophy'),('Picture Books'),('Poetry'),('Political Fiction'),('Politics'),('Popular Science'),('Pre school and Early Learning'),('Psychological Thriller'),('Puzzles'),('Religion and Spirituality'),('Romance'),('Satire'),('Science'),('Science Fiction'),('Science Fiction and Fantasy'),('Self Help'),('Short Stories'),('Sports'),('Spy Fiction'),('Suspense'),('Technology'),('Thriller'),('Thriller and Adventure'),('Transport General'),('Travel'),('Travel Writing'),('Trivia and Quiz Books'),('True Crime'),('Urban Fantasy'),('Usage and Writing Guides'),('War Fiction'),('Western'),('Young Adult'),('Young Adult Fiction');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `link`
--

DROP TABLE IF EXISTS `link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `link` (
  `url` varchar(512) NOT NULL,
  `format_type` enum('Hardcover','Paperback','PDF','eBook','Audiobook') NOT NULL,
  `book_id` int NOT NULL,
  PRIMARY KEY (`url`),
  KEY `link_fk_book` (`book_id`),
  CONSTRAINT `link_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `link`
--

LOCK TABLES `link` WRITE;
/*!40000 ALTER TABLE `link` DISABLE KEYS */;
INSERT INTO `link` VALUES ('https://archive.org/details/TheDaVinciCode_201308','PDF',1),('https://www.amazon.com/Angels-and-Demons-Dan-Brown-audiobook/dp/B00023O1L4','Audiobook',3),('https://www.amazon.com/Angels-Demons-Dan-Brown-ebook/dp/B000FBJFSM','eBook',3),('https://www.amazon.com/Angels-Demons-Dan-Brown/dp/0743486226','Hardcover',3),('https://www.amazon.com/Angels-Demons-Novel-Robert-Langdon/dp/074349346X','Paperback',3),('https://www.amazon.com/Harry-Potter-Chamber-Secrets-Book/dp/133887893X','Paperback',3),('https://www.amazon.com/Harry-Potter-Chamber-Secrets-Book/dp/B017V4IPPO','Audiobook',3),('https://www.amazon.com/Harry-Potter-Chamber-Secrets-Rowling-ebook/dp/B0192CTMW8','eBook',3),('https://www.amazon.com/Harry-Potter-Chamber-Secrets-Rowling/dp/0439064864','Hardcover',3),('https://www.amazon.com/Harry-Potter-Philosophers-Stone-Rowling/dp/1408855658','Paperback',2),('https://www.amazon.com/Harry-Potter-Sorcerers-Stone-Book/dp/B017V4IMVQ','Audiobook',2),('https://www.amazon.com/Harry-Potter-Sorcerers-Stone-Rowling-ebook/dp/B0192CTMYG','eBook',2),('https://www.amazon.com/Harry-Potter-Sorcerers-Stone-Rowling/dp/0590353403','Hardcover',2),('https://www.amazon.com/Vinci-Code-Dan-Brown/dp/0385504209','Hardcover',1),('https://www.amazon.com/Vinci-Code-Novel-Robert-Langdon-ebook/dp/B000FA675C','eBook',1),('https://www.amazon.com/Vinci-Code-Robert-Langdon/dp/0307474275','Paperback',1);
/*!40000 ALTER TABLE `link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `publisher_id` int NOT NULL AUTO_INCREMENT,
  `publisher_name` varchar(128) NOT NULL,
  `email_address` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`publisher_id`),
  UNIQUE KEY `publisher_ak_name` (`publisher_name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'Transworld Grp','h24bh8@outlook.com'),(2,'Bloomsbury Grp','zpli8@hotmail.com'),(3,'Little, Brown Book Grp','2mly7dvoj@example.com'),(4,'Pan Macmillan Grp','nwv45sssjc@yahoo.com'),(5,'Random House Grp','f32kieik33@hotmail.com'),(6,'Quercus Grp','j8k58j3epq1@gmail.com'),(7,'Penguin Grp','ckom1ds@hotmail.com'),(8,'Orion Grp','hra4d5hjkz@example.com'),(9,'HarperCollins Grp','1yznhi@yahoo.com'),(10,'Headline Grp','5ddbi@gmail.com'),(11,'Canongate Grp','r3nvm94j9z4@hotmail.com'),(12,'Profile Books Group','yonmvaiw@gmail.com'),(13,'Scholastic Ltd. Grp','r33hxfz1@hotmail.com');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `series`
--

DROP TABLE IF EXISTS `series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `series` (
  `series_id` int NOT NULL AUTO_INCREMENT,
  `series_name` varchar(128) NOT NULL,
  PRIMARY KEY (`series_id`),
  UNIQUE KEY `series_ak` (`series_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `series`
--

LOCK TABLES `series` WRITE;
/*!40000 ALTER TABLE `series` DISABLE KEYS */;
INSERT INTO `series` VALUES (1,'Bridget Jones'),(2,'Delia\'s How to Cook'),(3,'Harry Potter'),(4,'His Dark Materials'),(5,'Jamie Oliver\'s Cooking'),(6,'Millennium Trilogy'),(7,'Robert Langdon'),(8,'The Naked Chef'),(9,'Twilight');
/*!40000 ALTER TABLE `series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_name` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('jack','password1',1),('sai','password2',1),('sebastian','password3',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-05  1:41:26

-- PROCEDURES

USE virtual_library_db;

SET GLOBAL max_sp_recursion_depth = 64;

DROP PROCEDURE IF EXISTS LoginUser;
DELIMITER $$

-- Login User
CREATE PROCEDURE LoginUser (
    IN username_p VARCHAR(64),
    IN password_p VARCHAR(64)
)
BEGIN
    DECLARE stored_password VARCHAR(64);

    -- Retrieve the stored password for the given username
    SELECT password INTO stored_password
    FROM user
    WHERE user_name = username_p;

    -- Return the login status directly
    IF stored_password IS NULL THEN
        SELECT 'User Not Found' AS login_status;
    ELSEIF stored_password = password_p THEN
        SELECT 'Login Successful' AS login_status;
    ELSE
        SELECT 'Invalid Password' AS login_status;
    END IF;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS AddUser;
DELIMITER $$
-- Add User
CREATE PROCEDURE AddUser (
    IN username_p VARCHAR(64),
    IN password_p VARCHAR(64)
)
BEGIN
    -- Check if the username already exists
    IF EXISTS (SELECT 1 FROM user WHERE user_name = username_p) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    ELSE
        -- Insert the new user
        INSERT INTO user (user_name, password)
        VALUES (username_p, password_p);
    END IF;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS GetBooksByFilters;
DELIMITER $$
CREATE PROCEDURE GetBooksByFilters (
    IN genreName_p VARCHAR(64),
    IN bookName_p VARCHAR(256),
    IN publisherName_p VARCHAR(128),
    IN authorName_p VARCHAR(128),
    IN seriesName_p VARCHAR(128),
    IN username_p VARCHAR(64)
)
BEGIN
    -- Create the FilteredBookList table if it doesn't exist
    CREATE TABLE IF NOT EXISTS FilteredBookList (
        username VARCHAR(64),
        book_id INT,
        book_title VARCHAR(256),
        release_date DATE,
        genres VARCHAR(256),
        publisher_name VARCHAR(128),
        author_name VARCHAR(128),
        series_name VARCHAR(128),
        rating INT,
        comments TEXT,
        PRIMARY KEY (username, book_id)
    );

    -- Delete existing data for this user
    DELETE FROM FilteredBookList WHERE username = username_p;

    -- Populate FilteredBookList with filtered data
    INSERT INTO FilteredBookList (username, book_id, book_title, release_date, genres, publisher_name, author_name, series_name, rating, comments)
    SELECT
        username_p AS username,
        b.book_id,
        b.book_title,
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
        p.publisher_name,
        a.author_name,
        s.series_name,
        br.score AS rating,
        br.text AS comments
    FROM book b
    LEFT JOIN book_genre bg ON b.book_id = bg.book_id
    LEFT JOIN genre g ON bg.genre_name = g.genre_name
    LEFT JOIN publisher p ON b.publisher_id = p.publisher_id
    LEFT JOIN author a ON b.author_id = a.author_id
    LEFT JOIN book_series bs ON b.book_id = bs.book_id
    LEFT JOIN series s ON bs.series_id = s.series_id
    LEFT JOIN book_rating br ON b.book_id = br.book_id AND br.user_name = username_p
    WHERE
        (genreName_p IS NULL OR EXISTS (
            SELECT 1 FROM book_genre bg2 WHERE bg2.book_id = b.book_id AND bg2.genre_name = genreName_p
        )) AND
        (bookName_p IS NULL OR b.book_title = bookName_p) AND
        (publisherName_p IS NULL OR p.publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR a.author_name = authorName_p) AND
        (seriesName_p IS NULL OR s.series_name = seriesName_p)
    GROUP BY b.book_id, b.book_title, b.release_date, p.publisher_name, a.author_name, s.series_name, br.score, br.text;

    -- Return the filtered list for the user
    SELECT * FROM FilteredBookList WHERE username = username_p;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS FilterOnFilteredList;
DELIMITER $$

CREATE PROCEDURE FilterOnFilteredList (
    IN genreName_p VARCHAR(64),
    IN bookName_p VARCHAR(256),
    IN publisherName_p VARCHAR(128),
    IN authorName_p VARCHAR(128),
    IN seriesName_p VARCHAR(128),
    IN username_p VARCHAR(64)
)
BEGIN
    -- Ensure FilteredBookList exists for this user
    IF NOT EXISTS (
        SELECT 1 FROM FilteredBookList WHERE username = username_p
    ) THEN
        SIGNAL SQLSTATE '02000'
        SET MESSAGE_TEXT = 'FilteredBookList does not exist for this user. Run GetBooksByFilters first.';
    END IF;

    -- Create a temporary table to hold filtered results
    CREATE TEMPORARY TABLE TempFilteredList AS
    SELECT
        username,
        book_id,
        book_title,
        release_date,
        genres,
        publisher_name,
        author_name,
        series_name,
        rating,
        comments
    FROM FilteredBookList
    WHERE username = username_p AND
        (genreName_p IS NULL OR FIND_IN_SET(genreName_p, genres)) AND
        (bookName_p IS NULL OR book_title = bookName_p) AND
        (publisherName_p IS NULL OR publisher_name = publisherName_p) AND
        (authorName_p IS NULL OR author_name = authorName_p) AND
        (seriesName_p IS NULL OR series_name = seriesName_p);

    -- Replace FilteredBookList with the filtered results for this user
    DELETE FROM FilteredBookList WHERE username = username_p;
    INSERT INTO FilteredBookList
    SELECT * FROM TempFilteredList;

    -- Drop the temporary table
    DROP TEMPORARY TABLE TempFilteredList;

    -- Return the updated FilteredBookList for the user
    SELECT * FROM FilteredBookList WHERE username = username_p;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS AddOrUpdateBookRating;
DELIMITER $$

-- Add or Update Book Rating
CREATE PROCEDURE AddOrUpdateBookRating (
    IN username_p VARCHAR(64),
    IN bookId_p INT,
    IN ratingText_p TEXT,
    IN ratingScore_p INT
)
BEGIN
    -- Ensure the rating is within the valid range
    IF ratingScore_p < 1 OR ratingScore_p > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating score must be between 1 and 5.';
    END IF;

    -- Check if the rating already exists
    IF EXISTS (
        SELECT 1 FROM book_rating
        WHERE user_name = username_p AND book_id = bookId_p
    ) THEN
        -- Update the existing rating
        UPDATE book_rating
        SET text = ratingText_p, score = ratingScore_p
        WHERE user_name = username_p AND book_id = bookId_p;
    ELSE
        -- Insert a new rating
        INSERT INTO book_rating (user_name, book_id, text, score)
        VALUES (username_p, bookId_p, ratingText_p, ratingScore_p);
    END IF;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS DropFilteredList;
DELIMITER $$
-- Drop Filtered List
CREATE PROCEDURE DropFilteredList ()
BEGIN
    -- Drop the FilteredBookList table
    DROP TABLE IF EXISTS FilteredBookList;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS GetBookById;
DELIMITER $$
-- Get Book By ID
CREATE PROCEDURE GetBookById (
    IN bookId_p INT
)
BEGIN
    -- Select the book name and book ID for the given book ID
    SELECT book_id, book_title
    FROM book
    WHERE book_id = bookId_p;

    -- Handle cases where no book is found (optional)
    IF ROW_COUNT() = 0 THEN
        SELECT CONCAT('No book found with ID: ', bookId_p) AS message;
    END IF;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS CreateSubList;
DELIMITER $$

CREATE PROCEDURE CreateSubList (
    IN username_p VARCHAR(64),
    IN subListName_p VARCHAR(64),
    OUT subListStatus_p VARCHAR(32)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = username_p
    ) THEN
        SET subListStatus_p = 'User Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the sub-list already exists
    IF EXISTS (
        SELECT 1
        FROM user_book_list
        WHERE book_list_name = subListName_p
          AND user_name = username_p
    ) THEN
        SET subListStatus_p = 'Sub-List Already Exists';
    ELSE
        -- Create the sub-list
        INSERT INTO user_book_list (user_name, book_list_name)
        VALUES (username_p, subListName_p);

        SET subListStatus_p = 'Sub-List Created';
    END IF;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS AddBookToSubList;
DELIMITER $$

CREATE PROCEDURE AddBookToSubList (
    IN input_user_name VARCHAR(64),
    IN input_sub_list_name VARCHAR(64),
    IN input_book_id INT,
    OUT book_add_status VARCHAR(32)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SET book_add_status = 'User Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the sub-list exists for the user
    IF NOT EXISTS (
        SELECT 1
        FROM book_list
        WHERE user_name = input_user_name
          AND list_name = input_sub_list_name
    ) THEN
        SET book_add_status = 'Sub-List Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the book exists
    IF NOT EXISTS (
        SELECT 1 FROM book WHERE book_id = input_book_id
    ) THEN
        SET book_add_status = 'Book Not Found';
        LEAVE proc_block;
    END IF;

    -- Check if the book is already in the sub-list
    IF EXISTS (
        SELECT 1
        FROM book_list_book blb
        WHERE blb.book_list_name = input_sub_list_name
          AND blb.book_id = input_book_id
    ) THEN
        SET book_add_status = 'Book Already in Sub-List';
    ELSE
        -- Add the book to the sub-list
        INSERT INTO book_list_book (book_list_name, user_name, book_id)
        VALUES (input_sub_list_name, input_user_name, input_book_id);

        SET book_add_status = 'Book Added to Sub-List';
    END IF;

END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS RemoveBookFromUserList;
DELIMITER $$

CREATE PROCEDURE RemoveBookFromUserList (
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64),
    IN input_book_id INT

)
BEGIN
    -- Check if the book exists in the user's list
    IF EXISTS (
        SELECT 1
        FROM book_list_book blb
        JOIN book_list bl ON blb.book_list_name = bl.list_name
        WHERE bl.user_name = input_user_name
          AND bl.list_name = input_book_list_name
          AND blb.book_id = input_book_id
    ) THEN
        -- Remove the book from the list
        DELETE blb
        FROM book_list_book blb
        JOIN book_list bl ON blb.book_list_name = bl.list_name
        WHERE bl.user_name = input_user_name
          AND bl.list_name = input_book_list_name
          AND blb.book_id = input_book_id;


    END IF;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS return_list_name_of_user;



/*
Procedure to view a list of names of booklists associated with a specific user.
*/
DELIMITER $$
CREATE PROCEDURE return_list_name_of_user(user_name_p VARCHAR(64))
BEGIN
	SELECT bl.list_name
    FROM book_list bl
    WHERE bl.user_name = user_name_p;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS fetch_books_in_list;
DELIMITER $$
CREATE PROCEDURE fetch_books_in_list(
    IN book_list_name_p VARCHAR(64),
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT
        b.book_id,
        b.book_title,
        b.release_date,
        GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres,
        a.author_name,
        p.publisher_name,
        s.series_name,
        br.score AS rating,
        br.text AS comments
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    JOIN book b USING(book_id)
    LEFT JOIN book_genre bg USING(book_id)
    LEFT JOIN genre g USING(genre_name)
    LEFT JOIN author a USING(author_id)
    LEFT JOIN publisher p USING(publisher_id)
    LEFT JOIN book_series bs USING(book_id)
    LEFT JOIN series s USING(series_id)
    LEFT JOIN book_rating br
        ON b.book_id = br.book_id AND br.user_name = username_p -- Filter by specific user
    WHERE bl.list_name = book_list_name_p
    GROUP BY b.book_id, b.book_title, b.release_date, a.author_name, p.publisher_name, s.series_name, br.score, br.text
    ORDER BY b.book_id;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS CreateUserBookList;

/*
Procedure that creates a new user book list
*/
DELIMITER $$
CREATE PROCEDURE CreateUserBookList(
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SELECT 'Error: User does not exist' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Check if the book list already exists for the user
    IF EXISTS (
        SELECT 1
        FROM book_list
        WHERE list_name = input_book_list_name AND user_name = input_user_name
    ) THEN
        SELECT 'Error: Book List already exists for this user' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Insert the new book list for the user
    INSERT INTO book_list (list_name, user_name)
    VALUES (input_book_list_name, input_user_name);

    SELECT 'Success: Book List Created Successfully' AS status_message;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS delete_book_list;
DELIMITER $$

CREATE PROCEDURE delete_book_list(
    IN input_user_name VARCHAR(64),
    IN input_book_list_name VARCHAR(64)
)
proc_block: BEGIN
    -- Check if the user exists
    IF NOT EXISTS (
        SELECT 1 FROM user WHERE user_name = input_user_name
    ) THEN
        SELECT 'Error: User does not exist' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Check if the book list exists for the user
    IF NOT EXISTS (
        SELECT 1
        FROM book_list
        WHERE list_name = input_book_list_name AND user_name = input_user_name
    ) THEN
        SELECT 'Error: Book List does not exist for this user' AS status_message;
        LEAVE proc_block;
    END IF;

    -- Delete any related entries in other tables (e.g., book_list_book)
    DELETE FROM book_list_book WHERE book_list_name = input_book_list_name;

    -- Delete the book list
    DELETE FROM book_list WHERE list_name = input_book_list_name AND user_name = input_user_name;

    -- Return success message
    SELECT 'Success: Book List Deleted Successfully' AS status_message;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS FetchUserGenres;
DELIMITER $$

CREATE PROCEDURE FetchUserGenres(
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT DISTINCT g.genre_name AS genres
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    JOIN book_genre bg USING(book_id)
    JOIN genre g USING(genre_name)
    WHERE bl.user_name = username_p
    ORDER BY g.genre_name;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS CountUserBooks;
DELIMITER $$

CREATE PROCEDURE CountUserBooks(
    IN username_p VARCHAR(64)
)
BEGIN
    SELECT COUNT(DISTINCT blb.book_id) AS total_unique_books
    FROM book_list_book blb
    JOIN book_list bl ON blb.book_list_name = bl.list_name
    WHERE bl.user_name = username_p;
END $$

DELIMITER ;
DROP PROCEDURE IF EXISTS MostReadGenre;
DELIMITER $$
CREATE PROCEDURE MostReadGenre(IN user_name_p VARCHAR(64))
BEGIN
    -- Find the maximum count of genres
    DECLARE max_count INT;

    SELECT MAX(genre_count) INTO max_count
    FROM (
        SELECT bg.genre_name, COUNT(*) AS genre_count
        FROM book_list_book blb
        JOIN book_genre bg ON blb.book_id = bg.book_id
        WHERE blb.user_name = user_name_p
        GROUP BY bg.genre_name
    ) AS genre_counts;

    -- Select all genres with the maximum count
    SELECT bg.genre_name, COUNT(*) AS count
    FROM book_list_book blb
    JOIN book_genre bg ON blb.book_id = bg.book_id
    WHERE blb.user_name = user_name_p
    GROUP BY bg.genre_name
    HAVING count = max_count
    ORDER BY bg.genre_name;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS AuthorDiversity;
DELIMITER $$
CREATE PROCEDURE AuthorDiversity(IN user_name_p VARCHAR(64))
BEGIN
    SELECT COUNT(DISTINCT a.author_id) AS unique_authors
    FROM book_list_book blb
    JOIN book b ON blb.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
    WHERE blb.user_name = user_name_p;
END $$
DELIMITER ;
DROP PROCEDURE IF EXISTS TopAuthor;
DELIMITER $$
CREATE PROCEDURE TopAuthor(IN user_name_p VARCHAR(64))
BEGIN
    SELECT a.author_name, COUNT(*) AS book_count
    FROM book_list_book blb
    JOIN book b ON blb.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
    WHERE blb.user_name = user_name_p
    GROUP BY a.author_name
    ORDER BY book_count DESC
    LIMIT 1;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetBookFormatsAndURLs;
DELIMITER $$

CREATE PROCEDURE GetBookFormatsAndURLs (
    IN input_book_id INT
)
BEGIN
    SELECT
        b.book_id,
        b.book_title,
        l.url AS format_url,
        l.format_type AS format_type
    FROM book b
    LEFT JOIN link l ON b.book_id = l.book_id
    WHERE b.book_id = input_book_id;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book_to_series;
DELIMITER //

CREATE PROCEDURE add_book_to_series(book_title_p VARCHAR(256), release_date_p DATE, series_name_p VARCHAR(128))

BEGIN
    DECLARE book_id_v INT;
    DECLARE book_not_in_db_error VARCHAR(512);
    DECLARE book_already_in_series_error VARCHAR(512);
    DECLARE series_id_v INT;

    SET book_not_in_db_error = CONCAT('book: ', book_title_p, ', does not exist in the book table');
    SET book_already_in_series_error = CONCAT('book: ', book_title_p, ', is already associated with the series: ',
                                              series_name_p, '.');

    IF EXISTS (
        SELECT
            1
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SET book_id_v = (SELECT book_id FROM book WHERE book_title = book_title_p AND release_date = release_date_p);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_not_in_db_error;
    END IF ;

    IF NOT EXISTS(
        SELECT
            1
        FROM series s
        WHERE 1=1
            AND s.series_name = series_name_p
    ) THEN
        INSERT INTO series (series_name)
        VALUES (series_name_p);
    END IF ;

    SET series_id_v = (SELECT series_id FROM series WHERE series_name = series_name_p);

    IF EXISTS (
        SELECT
            1
        FROM book_series bs
        WHERE 1=1
            AND bs.series_id = series_id_v
            AND bs.book_id = book_id_v
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_already_in_series_error;
    ELSE
        INSERT INTO book_series (book_id, series_id)
        VALUES (book_id_v, series_id_v);
    END IF ;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book_to_user_list;
DELIMITER //
CREATE PROCEDURE add_book_to_user_list(user_name_p VARCHAR(64), book_list_name_p VARCHAR(64),
                                       book_title_p VARCHAR(256), release_date_p DATE)

BEGIN

    DECLARE book_in_book_list_error VARCHAR(512);
    DECLARE book_id_v INT;

    SET book_in_book_list_error = CONCAT('book: ', book_title_p, ', is already in booklist: ', book_list_name_p, '.');

    IF EXISTS (
        SELECT
            1
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SET book_id_v = (SELECT book_id FROM book WHERE book_title = book_title_p AND release_date = release_date_p);
    END IF ;

    IF NOT EXISTS (
        SELECT
            1 AS 'book_list_in_db'
        FROM book_list bl
        WHERE 1=1
            AND bl.list_name = book_list_name_p
            AND bl.user_name = user_name_p
    ) THEN
        INSERT INTO book_list (list_name, user_name)
        VALUES (book_list_name_p, user_name_p);
    END IF ;

    IF EXISTS (
        SELECT
            1 AS 'book_in_book_list'
        FROM book_list_book blb
        WHERE 1=1
            AND blb.book_list_name = book_list_name_p
            AND blb.user_name = user_name_p
            AND blb.book_id = book_id_v
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_in_book_list_error;
    ELSE
        INSERT INTO book_list_book (book_list_name, user_name, book_id)
        VALUES (book_list_name_p, user_name_p, book_id_v);
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book;
DELIMITER //

CREATE PROCEDURE add_book(book_title_p VARCHAR(256), author_id_p INT,
                          publisher_id_p INT, release_date_p DATE)

BEGIN
    DECLARE book_in_db_error VARCHAR(64);
    DECLARE future_release_date_error VARCHAR(128);

    SET book_in_db_error = CONCAT('Book: ', book_title_p, ', already exists in the book table.');
    SET future_release_date_error = CONCAT('Future release date: , ', release_date_p, ', is invalid.');

    IF release_date_p > NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = future_release_date_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'book in db'
        FROM book b
        WHERE 1=1
        AND b.book_title = book_title_p
        AND b.release_date = release_date_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_in_db_error;
    ELSE
        INSERT INTO book(book_title, author_id, publisher_id, release_date)
        VALUES (book_title_p, author_id_p, publisher_id_p, release_date_p);
    END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_genre_to_book;
DELIMITER //

CREATE PROCEDURE add_genre_to_book(book_title_p VARCHAR(256), release_date_p DATE, genre_name_p VARCHAR(64))
BEGIN
    DECLARE book_not_in_db_error VARCHAR(512);
    DECLARE book_id_v INT;
    DECLARE blank_param_error VARCHAR(32);
    DECLARE book_genre_in_db VARCHAR(512);

    SET book_not_in_db_error = CONCAT('book: ', book_title_p, ', does not exist in the book table');
    SET blank_param_error = ('No parameters can be empty');
    SET book_genre_in_db = CONCAT('book: ', book_title_p, ', with genre: ', genre_name_p,
                                  ', is already in book_genre table');

    IF book_title_p = '' OR genre_name_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_param_error;
    ELSEIF NOT EXISTS (
        SELECT
            1 AS 'book in db'
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_not_in_db_error;
    ELSEIF NOT EXISTS(
        SELECT
            1 AS 'genre_in_genres'
        FROM genre g
        WHERE 1=1
            AND g.genre_name = genre_name_p
    ) THEN
        INSERT INTO genre (genre_name)
        VALUES (genre_name_p);
    END IF;

    SET book_id_v = (
        SELECT
            b.book_id
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
        );

    IF EXISTS (
        SELECT
            1
        FROM book_genre bg
        WHERE 1=1
            AND bg.book_id = book_id_v
            AND bg.genre_name = genre_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = book_genre_in_db;
    ELSE
        INSERT INTO book_genre (book_id, genre_name)
        VALUES (book_id_v, genre_name_p);
    END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_book_from_import;
DELIMITER //

-- Adds a book to the book table
CREATE PROCEDURE add_book_from_import(book_title_p VARCHAR(256), author_name_p VARCHAR(128),
                          author_email_p VARCHAR(64), publisher_name_p VARCHAR(128), publisher_email_p VARCHAR(64),
                          release_date_p DATE)

BEGIN

    DECLARE author_id_v INT;
    DECLARE publisher_id_v INT;

    IF NOT EXISTS (
        SELECT
            1
        FROM author a
        WHERE a.author_name = author_name_p
    ) THEN
        CALL add_author(author_name_p, author_email_p);
    END IF ;
    IF NOT EXISTS (
        SELECT
            1
        FROM publisher p
        WHERE p.publisher_name = publisher_name_p
    ) THEN
        CALL add_publisher(publisher_name_p, publisher_email_p);
    END IF ;

    SET author_id_v = (
        SELECT
            author_id
        FROM author a
        WHERE a.author_name = author_name_p
    );

    SET publisher_id_v = (
        SELECT
            publisher_id
        FROM publisher a
        WHERE a.publisher_name = publisher_name_p
    );

    IF NOT EXISTS (
        SELECT
            1
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        CALL add_book(book_title_p, author_id_v, publisher_id_v, release_date_p);
    END IF ;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS add_author;

DELIMITER //
CREATE PROCEDURE add_author(author_name_p VARCHAR(128), author_email_p VARCHAR(64))

BEGIN

    DECLARE author_in_db_error VARCHAR(256);
    DECLARE blank_author_error VARCHAR(64);

    SET author_in_db_error = CONCAT('Author: ', author_name_p, ', already exists in author table.');
    SET blank_author_error = CONCAT('Author name cannot be blank.');

    IF author_name_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_author_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'author in db'
        FROM author a
        WHERE 1=1
        AND a.author_name = author_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = author_in_db_error;
    ELSEIF author_email_p = '' THEN
        INSERT INTO author (author_name, email_address)
        VALUES (author_name_p, NULL);
    ELSE
        INSERT INTO author (author_name, email_address)
        VALUES (author_name_p, author_email_p);
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_publisher;

DELIMITER //
CREATE PROCEDURE add_publisher(publisher_name_p VARCHAR(128), publisher_email_p VARCHAR(64))

BEGIN

    DECLARE publisher_in_db_error VARCHAR(256);
    DECLARE blank_publisher_error VARCHAR(64);

    SET publisher_in_db_error = CONCAT('Publisher: ', publisher_name_p, ', already exists in publisher table.');
    SET blank_publisher_error = CONCAT('Publisher name cannot be blank.');

    IF publisher_name_p = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = blank_publisher_error;
    ELSEIF EXISTS (
        SELECT
            1 AS 'publisher in db'
        FROM publisher p
        WHERE 1=1
        AND p.publisher_name = publisher_name_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = publisher_in_db_error;
    ELSEIF publisher_email_p = '' THEN
        INSERT INTO publisher (publisher_name, email_address)
        VALUES (publisher_name_p, NULL);
    ELSE
        INSERT INTO publisher (publisher_name, email_address)
        VALUES (publisher_name_p, publisher_email_p);
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS add_link;

DELIMITER //
CREATE PROCEDURE add_link(url_p VARCHAR(512), format_type_p VARCHAR(64),
                          book_title_p VARCHAR(256), release_date_p DATE)

BEGIN
    DECLARE url_in_db_error VARCHAR(256);
    DECLARE invalid_format_error VARCHAR(256);
    DECLARE invalid_book_title VARCHAR(256);
    DECLARE book_id_v INT;

	SET url_in_db_error = CONCAT('url: ', url_p, ', already exists in the link table.');
	SET invalid_format_error = CONCAT('book format type: ',
                                      format_type_p,
                                      ', is invalid. Please enter either: Hardcover, Paperback, PDF, eBook, or Audiobook.');
    SET invalid_book_title = CONCAT('book title: ', book_title_p, ', does not exist in the book table.');

    IF EXISTS (
        SELECT
            1 AS 'link in db'
        FROM link l
        WHERE 1=1
        AND l.url = url_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = url_in_db_error;
    ELSEIF format_type_p NOT IN ('Hardcover', 'Paperback', 'PDF', 'eBook', 'Audiobook') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = invalid_format_error;
    ELSEIF NOT EXISTS (
        SELECT
            1 AS 'book_id in db'
        FROM book b
        WHERE 1=1
            AND b.book_title = book_title_p
            AND b.release_date = release_date_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = invalid_book_title;
    ELSE
        SET book_id_v = (
            SELECT
                b.book_id
            FROM book b
            WHERE 1=1
                AND b.book_title = book_title_p
                AND b.release_date = release_date_p
            );

        INSERT INTO link (url, format_type, book_id)
        VALUES (url_p, format_type_p, book_id_v);

    END IF;

END //

DELIMITER ;


DROP PROCEDURE IF EXISTS delete_user;
DELIMITER //

CREATE PROCEDURE delete_user(username_p VARCHAR(64))

BEGIN
    DECLARE username_not_in_db_error VARCHAR(64);
    SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = username_not_in_db_error;
    ELSE
        DELETE FROM user u WHERE u.user_name = username_p;
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS make_user_admin;
DELIMITER //

CREATE PROCEDURE make_user_admin(username_p VARCHAR(64))

BEGIN
    DECLARE username_not_in_db_error VARCHAR(64);
    DECLARE user_already_admin VARCHAR(64);
    SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');
    SET user_already_admin = CONCAT('User, ', username_p, ', is already an Admin');

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = username_not_in_db_error;
    ELSEIF EXISTS (
        SELECT
            1
        FROM user u
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = user_already_admin;
	ELSE
        UPDATE user u
            SET u.is_admin = TRUE
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = FALSE;
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS demote_user_from_admin;
DELIMITER //

CREATE PROCEDURE demote_user_from_admin(username_p VARCHAR(64))

BEGIN
    DECLARE username_not_in_db_error VARCHAR(64);
    DECLARE user_not_admin VARCHAR(64);
    SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');
    SET user_not_admin = CONCAT('User, ', username_p, ', was not an Admin');

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
	    ) THEN
	        SIGNAL SQLSTATE '45000'
	        SET MESSAGE_TEXT = username_not_in_db_error;
    ELSEIF EXISTS (
        SELECT
            1
        FROM user u
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = FALSE
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = user_not_admin;
	ELSE
        UPDATE user u
            SET u.is_admin = FALSE
        WHERE 1=1
            AND u.user_name = username_p
            AND u.is_admin = TRUE;
    END IF;

END //

DELIMITER ;

DROP PROCEDURE IF EXISTS update_username;
DELIMITER //

CREATE PROCEDURE update_username(old_username_p VARCHAR(64), new_username_p VARCHAR(64))

BEGIN
	 DECLARE username_not_in_db_error VARCHAR(64);
	 SET username_not_in_db_error = CONCAT('User, ', old_username_p, ', does not exist');

	 IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = old_username_p
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = username_not_in_db_error;
     ELSE
	     UPDATE user u
	        SET u.user_name = new_username_p
	     WHERE u.user_name = old_username_p;
	 END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS update_password;
DELIMITER //

CREATE PROCEDURE update_password(username_p VARCHAR(64), new_password_p VARCHAR(64))

BEGIN
	 DECLARE username_not_in_db_error VARCHAR(64);
	 SET username_not_in_db_error = CONCAT('User, ', username_p, ', does not exist');

	 IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = username_not_in_db_error;
     ELSE
	     UPDATE user u
	        SET u.password = new_password_p
	     WHERE u.user_name = username_p;
	 END IF;
END //

DELIMITER ;

DROP PROCEDURE IF EXISTS view_users;
DELIMITER //

CREATE PROCEDURE view_users()
    BEGIN
        SELECT
            u.user_name
            , u.is_admin
        FROM user u;
    END //

DELIMITER ;

DROP FUNCTION IF EXISTS is_user_admin;
DELIMITER //

CREATE FUNCTION is_user_admin(username_p VARCHAR(64))
RETURNS BOOL
READS SQL DATA
BEGIN
    DECLARE is_admin BOOL;

    IF NOT EXISTS (
        SELECT
            1
        FROM user u
        WHERE u.user_name = username_p
            AND u.is_admin = TRUE
    ) THEN
        SET is_admin = FALSE;
    ELSE
        SET is_admin = TRUE;
    END IF;

    RETURN is_admin;
END //

DELIMITER ;