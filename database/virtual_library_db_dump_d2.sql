CREATE DATABASE  IF NOT EXISTS `virtual_library_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `virtual_library_db`;
-- MySQL dump 10.13  Distrib 8.0.38, for macos14 (arm64)
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
  `email_address` varchar(64) NOT NULL,
  PRIMARY KEY (`author_id`),
  UNIQUE KEY `author_ak_name` (`author_name`),
  UNIQUE KEY `author_ak_email` (`email_address`)
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
  `description` text,
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
INSERT INTO `book` VALUES (1,'The Da Vinci Code','While in Paris on business, Harvard symbologist Robert Langdon receives an urgent late-night phone call: the elderly curator of the Louvre has been murdered inside the museum. Near the body, police have found a baffling cipher. While working to solve the enigmatic riddle, Langdon is stunned to discover it leads to a trail of clues hidden in the works of Da Vinci -- clues visible for all to see -- yet ingeniously disguised by the painter. Langdon joins forces with a gifted French cryptologist, Sophie Neveu, and learns the late curator was involved in the Priory of Sion -- an actual secret society whose members included Sir Isaac Newton, Botticelli, Victor Hugo, and Da Vinci, among others. In a breathless race through Paris, London, and beyond, Langdon and Neveu match wits with a faceless powerbroker who seems to anticipate their every move. Unless Langdon and Neveu can decipher the labyrinthine puzzle in time, the Priory\'s ancient secret -- and an explosive historical truth -- will be lost forever. The Da Vinci Code heralds the arrival of a new breed of lightning-paced, intelligent thriller utterly unpredictable right up to its stunning conclusion.',10,2,'2004-03-01'),(2,'Harry Potter and the Philosopher\'s Stone','This is a fake description. But its only temporary',20,3,'1997-06-26'),(3,'Harry Potter and the Chamber of Secrets','This is a fake description. But its only temporary',20,3,'1999-04-01'),(4,'Angels and Demons','This is a fake description. But its only temporary',10,2,'2003-07-01'),(5,'Harry Potter and the Order of the Phoenix','This is a fake description. But its only temporary',20,3,'2003-06-21'),(6,'Harry Potter and the Half-blood Prince: Children\'s Edition','This is a fake description. But its only temporary',20,3,'2005-07-16'),(7,'Harry Potter and the Deathly Hallows','This is a fake description. But its only temporary',20,3,'2007-07-21'),(8,'Harry Potter and the Prisoner of Azkaban','This is a fake description. But its only temporary',20,3,'2000-04-01'),(9,'Twilight','This is a fake description. But its only temporary',54,4,'2007-03-22'),(10,'Harry Potter and the Goblet of Fire','This is a fake description. But its only temporary',20,3,'2001-07-06'),(11,'Deception Point','This is a fake description. But its only temporary',10,2,'2004-05-01'),(12,'New Moon','This is a fake description. But its only temporary',54,4,'2007-09-06'),(13,'The Lovely Bones','This is a fake description. But its only temporary',2,5,'2009-12-04'),(14,'Digital Fortress','This is a fake description. But its only temporary',10,2,'2004-03-05'),(15,'The Curious Incident of the Dog in the Night-time','This is a fake description. But its only temporary',39,6,'2004-04-01'),(16,'Eclipse','This is a fake description. But its only temporary',54,4,'2008-07-03'),(17,'The Girl with the Dragon Tattoo','This is a fake description. But its only temporary',55,7,'2008-07-24'),(18,'The Kite Runner','This is a fake description. But its only temporary',31,3,'2004-06-07'),(19,'The Time Traveler\'s Wife','This is a fake description. But its only temporary',5,6,'2004-05-29'),(20,'The World According to Clarkson','This is a fake description. But its only temporary',24,8,'2005-05-26'),(21,'Atonement','This is a fake description. But its only temporary',19,6,'2002-05-02'),(22,'The Lost Symbol','This is a fake description. But its only temporary',10,2,'2009-09-15'),(23,'A Short History of Nearly Everything','This is a fake description. But its only temporary',8,2,'2004-06-01'),(24,'Breaking Dawn','This is a fake description. But its only temporary',54,4,'2008-08-04'),(25,'Harry Potter and the Goblet of Fire','This is a fake description. But its only temporary',20,3,'2000-07-08'),(26,'The Girl Who Played with Fire','This is a fake description. But its only temporary',55,7,'2010-07-29'),(27,'A Child Called It','This is a fake description. But its only temporary',11,9,'2001-01-04'),(28,'No.1 Ladies\' Detective Agency','This is a fake description. But its only temporary',1,4,'2003-06-05'),(29,'You are What You Eat:The Plan That Will Change Your Life','This is a fake description. But its only temporary',16,8,'2004-06-17'),(30,'Man and Boy','This is a fake description. But its only temporary',56,10,'2000-03-06'),(31,'Birdsong','This is a fake description. But its only temporary',51,6,'1994-07-18'),(32,'Labyrinth','This is a fake description. But its only temporary',30,9,'2006-01-11'),(33,'The Island','This is a fake description. But its only temporary',57,11,'2006-04-10'),(34,'Life of Pi','This is a fake description. But its only temporary',58,12,'2003-05-17'),(35,'Dr. Atkins\' New Diet Revolution','This is a fake description. But its only temporary',50,6,'2003-01-02'),(36,'The Tales of Beedle the Bard','This is a fake description. But its only temporary',20,3,'2008-12-04'),(37,'Captain Corelli\'s Mandolin','This is a fake description. But its only temporary',35,6,'1995-06-01'),(38,'Delia\'s How to Cook: Book One','This is a fake description. But its only temporary',13,6,'1998-10-12'),(39,'The Gruffalo','This is a fake description. But its only temporary',28,5,'2009-03-06'),(40,'Eats, Shoots and Leaves: The Zero Tolerance Approach to Punctuation','This is a fake description. But its only temporary',36,13,'2003-11-06'),(42,'The Interpretation of Murder','This is a fake description. But its only temporary',23,11,'2007-01-15'),(43,'The Girl Who Kicked the Hornets\' Nest','This is a fake description. But its only temporary',55,7,'2010-04-01'),(44,'Bridget Jones: The Edge of Reason','This is a fake description. But its only temporary',18,5,'2000-06-15'),(45,'A Short History of Tractors in Ukrainian','This is a fake description. But its only temporary',38,8,'2006-03-02'),(46,'The Alchemist: A Fable About Following Your Dream','This is a fake description. But its only temporary',47,10,'1999-09-06'),(47,'Notes from a Small Island','This is a fake description. But its only temporary',8,2,'1996-08-01'),(48,'The Boy in the Striped Pyjamas','This is a fake description. But its only temporary',26,2,'2007-02-01'),(49,'Stupid White Men:...and Other Sorry Excuses for the State of the Nation','This is a fake description. But its only temporary',41,8,'2002-10-03'),(50,'Jamie\'s 30-minute Meals','This is a fake description. But its only temporary',22,8,'2010-09-30'),(51,'The Broker','This is a fake description. But its only temporary',27,6,'2005-08-27'),(52,'Bridget Jones\'s Diary: A Novel','This is a fake description. But its only temporary',18,5,'1997-06-20'),(53,'The Very Hungry Caterpillar','This is a fake description. But its only temporary',14,8,'1994-09-29'),(54,'A Thousand Splendid Suns','This is a fake description. But its only temporary',31,3,'2007-05-22'),(55,'The Sound of Laughter','This is a fake description. But its only temporary',48,6,'2006-10-05'),(56,'Jamie\'s Italy','This is a fake description. But its only temporary',22,8,'2005-10-03'),(57,'Small Island','This is a fake description. But its only temporary',3,11,'2004-09-13'),(58,'The Memory Keeper\'s Daughter','This is a fake description. But its only temporary',32,8,'2007-04-26'),(59,'Billy Connolly','This is a fake description. But its only temporary',44,10,'2002-07-08'),(60,'The House at Riverton','This is a fake description. But its only temporary',29,5,'2007-06-15'),(61,'Harry Potter and the Order of the Phoenix','This is a fake description. But its only temporary',20,3,'2004-07-10'),(62,'Nigella Express','This is a fake description. But its only temporary',43,6,'2007-09-06'),(63,'Memoirs of a Geisha','This is a fake description. But its only temporary',4,6,'1998-06-04'),(64,'Delia\'s How to Cook: Book Two','This is a fake description. But its only temporary',13,6,'1999-12-09'),(66,'Jamie\'s Ministry of Food: Anyone Can Learn to Cook in 24 Hours','This is a fake description. But its only temporary',22,8,'2008-10-03'),(67,'Jamie at Home: Cook Your Way to the Good Life','This is a fake description. But its only temporary',22,8,'2007-09-06'),(68,'White Teeth','This is a fake description. But its only temporary',59,8,'2001-01-25'),(69,'The Devil Wears Prada','This is a fake description. But its only temporary',33,10,'2003-10-06'),(70,'At My Mother\'s Knee ...:and Other Low Joints','This is a fake description. But its only temporary',46,2,'2008-09-24'),(71,'No Time for Goodbye','This is a fake description. But its only temporary',34,9,'2008-06-12'),(72,'Chocolat','This is a fake description. But its only temporary',25,2,'2000-03-02'),(73,'The Return of the Naked Chef','This is a fake description. But its only temporary',22,8,'2000-03-30'),(74,'Angela\'s Ashes: A Memoir of a Childhood','This is a fake description. But its only temporary',15,10,'1997-05-06'),(75,'Schott\'s Original Miscellany','This is a fake description. But its only temporary',7,3,'2002-11-04'),(76,'Dreams from My Father: A Story of Race and Inheritance','This is a fake description. But its only temporary',6,12,'2008-06-05'),(77,'The Dangerous Book for Boys','This is a fake description. But its only temporary',9,10,'2006-06-05'),(78,'To Kill a Mockingbird','This is a fake description. But its only temporary',17,6,'1989-10-05'),(79,'Harry Potter and the Half-blood Prince','This is a fake description. But its only temporary',20,3,'2005-07-16'),(80,'The Summons','This is a fake description. But its only temporary',27,6,'2002-09-28'),(81,'The Lost Symbol','This is a fake description. But its only temporary',10,2,'2010-07-22'),(82,'The Catcher in the Rye','This is a fake description. But its only temporary',21,8,'1994-08-04'),(83,'I Can Make You Thin','This is a fake description. But its only temporary',45,2,'2005-01-17'),(84,'Happy Days with the Naked Chef','This is a fake description. But its only temporary',22,8,'2001-09-03'),(85,'Brick Lane','This is a fake description. But its only temporary',42,2,'2004-05-01'),(86,'Anybody Out There?','This is a fake description. But its only temporary',37,8,'2007-02-08'),(87,'The Undomestic Goddess','This is a fake description. But its only temporary',53,2,'2006-01-02'),(88,'The Book Thief','This is a fake description. But its only temporary',40,2,'2008-01-01'),(89,'I Know You Got Soul','This is a fake description. But its only temporary',24,8,'2006-05-25'),(90,'Sharon Osbourne Extreme: My Autobiography','This is a fake description. But its only temporary',52,4,'2005-10-03'),(92,'Can You Keep a Secret?','This is a fake description. But its only temporary',53,2,'2003-03-17'),(93,'Down Under','This is a fake description. But its only temporary',8,2,'2001-08-06'),(94,'A Spot of Bother','This is a fake description. But its only temporary',39,6,'2007-06-07'),(95,'Dear Fatty','This is a fake description. But its only temporary',12,6,'2008-10-09');
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
INSERT INTO `book_genre` VALUES (28,'Autobiography General'),(56,'Autobiography General'),(75,'Autobiography General'),(77,'Autobiography Historical'),(71,'Autobiography The Arts'),(60,'Biography The Arts'),(2,'Children\'s Fiction'),(3,'Children\'s Fiction'),(5,'Children\'s Fiction'),(6,'Children\'s Fiction'),(7,'Children\'s Fiction'),(8,'Children\'s Fiction'),(10,'Children\'s Fiction'),(25,'Children\'s Fiction'),(37,'Children\'s Fiction'),(62,'Children\'s Fiction'),(1,'Crime'),(4,'Crime'),(11,'Crime'),(14,'Crime'),(17,'Crime'),(22,'Crime'),(27,'Crime'),(29,'Crime'),(43,'Crime'),(44,'Crime'),(52,'Crime'),(72,'Crime'),(81,'Crime'),(82,'Crime'),(50,'Current Affairs and Issues'),(30,'Fitness and Diet'),(36,'Fitness and Diet'),(84,'Fitness and Diet'),(39,'Food and Drink General'),(51,'Food and Drink General'),(63,'Food and Drink General'),(67,'Food and Drink General'),(68,'Food and Drink General'),(74,'Food and Drink General'),(85,'Food and Drink General'),(13,'General and Literary Fiction'),(15,'General and Literary Fiction'),(18,'General and Literary Fiction'),(19,'General and Literary Fiction'),(21,'General and Literary Fiction'),(31,'General and Literary Fiction'),(32,'General and Literary Fiction'),(33,'General and Literary Fiction'),(34,'General and Literary Fiction'),(35,'General and Literary Fiction'),(38,'General and Literary Fiction'),(45,'General and Literary Fiction'),(46,'General and Literary Fiction'),(47,'General and Literary Fiction'),(53,'General and Literary Fiction'),(55,'General and Literary Fiction'),(58,'General and Literary Fiction'),(59,'General and Literary Fiction'),(61,'General and Literary Fiction'),(64,'General and Literary Fiction'),(69,'General and Literary Fiction'),(70,'General and Literary Fiction'),(73,'General and Literary Fiction'),(79,'General and Literary Fiction'),(83,'General and Literary Fiction'),(86,'General and Literary Fiction'),(87,'General and Literary Fiction'),(88,'General and Literary Fiction'),(89,'General and Literary Fiction'),(93,'General and Literary Fiction'),(95,'General and Literary Fiction'),(78,'Hobbies'),(20,'Humour Collections and General'),(57,'National and Regional Cuisine'),(78,'Pastimes and Indoor'),(40,'Picture Books'),(23,'Popular Science'),(54,'Pre school and Early Learning'),(80,'Science Fiction and Fantasy'),(1,'Thriller and Adventure'),(4,'Thriller and Adventure'),(11,'Thriller and Adventure'),(14,'Thriller and Adventure'),(17,'Thriller and Adventure'),(22,'Thriller and Adventure'),(27,'Thriller and Adventure'),(29,'Thriller and Adventure'),(43,'Thriller and Adventure'),(44,'Thriller and Adventure'),(52,'Thriller and Adventure'),(72,'Thriller and Adventure'),(81,'Thriller and Adventure'),(82,'Thriller and Adventure'),(90,'Transport General'),(48,'Travel Writing'),(94,'Travel Writing'),(76,'Trivia and Quiz Books'),(9,'Young Adult Fiction'),(12,'Young Adult Fiction'),(16,'Young Adult Fiction'),(24,'Young Adult Fiction'),(42,'Young Adult Fiction'),(49,'Young Adult Fiction'),(66,'Young Adult Fiction'),(92,'Young Adult Fiction');
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
INSERT INTO `book_series` VALUES (44,1),(52,1),(38,2),(64,2),(2,4),(3,4),(5,4),(6,4),(8,4),(10,4),(25,4),(61,4),(79,4),(50,6),(56,6),(66,6),(67,6),(17,7),(26,7),(43,7),(1,8),(4,8),(73,9),(84,9),(9,10),(12,10),(16,10),(24,10);
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
INSERT INTO `genre` VALUES ('Adventure'),('Anthology'),('Art and Photography'),('Autobiography'),('Autobiography General'),('Autobiography Historical'),('Autobiography The Arts'),('Biography'),('Biography The Arts'),('Business'),('Children\'s Fiction'),('Children\'s Literature'),('Classics'),('Contemporary'),('Cookbooks'),('Crime'),('Current Affairs and Issues'),('Drama'),('Dystopian'),('Encyclopedias and General Reference'),('Essays'),('Family Saga'),('Fantasy'),('Fitness and Diet'),('Food and Drink General'),('General and Literary Fiction'),('Gothic'),('Graphic Novels'),('Health and Wellness'),('Historical Fiction'),('History'),('Hobbies'),('Horror'),('Humor'),('Humour Collections and General'),('Magical Realism'),('Memoir'),('Memoirs'),('Mystery'),('Mythology'),('National and Regional Cuisine'),('Paranormal'),('Pastimes and Indoor'),('Philosophy'),('Picture Books'),('Poetry'),('Political Fiction'),('Politics'),('Popular Science'),('Pre school and Early Learning'),('Psychological Thriller'),('Puzzles'),('Religion and Spirituality'),('Romance'),('Satire'),('Science'),('Science Fiction'),('Science Fiction and Fantasy'),('Self Help'),('Short Stories'),('Sports'),('Spy Fiction'),('Suspense'),('Technology'),('Thriller'),('Thriller and Adventure'),('Transport General'),('Travel'),('Travel Writing'),('Trivia and Quiz Books'),('True Crime'),('Urban Fantasy'),('Usage and Writing Guides'),('War Fiction'),('Western'),('Young Adult'),('Young Adult Fiction');
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
  `email_address` varchar(64) NOT NULL,
  PRIMARY KEY (`publisher_id`),
  UNIQUE KEY `publisher_ak_name` (`publisher_name`),
  UNIQUE KEY `publisher_ak_email` (`email_address`)
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `series`
--

LOCK TABLES `series` WRITE;
/*!40000 ALTER TABLE `series` DISABLE KEYS */;
INSERT INTO `series` VALUES (1,'Bridget Jones'),(2,'Delia\'s How to Cook'),(3,'Guinness World Records'),(4,'Harry Potter'),(5,'His Dark Materials'),(6,'Jamie Oliver\'s Cooking'),(7,'Millennium Trilogy'),(8,'Robert Langdon'),(9,'The Naked Chef'),(10,'Twilight');
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
  PRIMARY KEY (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('jack','password1'),('sai','password2'),('sebastian','password3');
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

-- Dump completed on 2024-11-27 20:46:03
