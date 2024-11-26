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
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'Dan Brown','xl6pua8xsg@yahoo.com'),(2,'J.K. Rowling','psesiy27o@yahoo.com'),(3,'E. L. James','crfoktr@yahoo.com'),(4,'Stephenie Meyer','wis0eka@gmail.com'),(5,'Stieg Larsson','tj39x5g84vw@outlook.com'),(6,'Alice Sebold','21qs4ve1ts1@yahoo.com'),(7,'Mark Haddon','5or1klxlc7@yahoo.com'),(8,'Bill Bryson','owwd3s@hotmail.com'),(9,'Eric Carle','i6wrokpk7@outlook.com'),(10,'Julia Donaldson','13cbhnh@example.com'),(11,'Jamie Oliver','zul0u0fta@example.com'),(12,'Khaled Hosseini','45ixeddypc42@gmail.com'),(13,'David Nicholls','ad4ti5gs7@gmail.com'),(14,'Audrey Niffenegger','386lj@hotmail.com'),(15,'Ian McEwan','abtkkzf52sz@outlook.com'),(16,'Helen Fielding','gcm7klejk@gmail.com'),(17,'Jeremy Clarkson','y99qab@outlook.com'),(18,'Louis de Bernieres','u9qa3adnq@yahoo.com'),(19,'Peter Kay','fdcmvi2w2ia@hotmail.com'),(20,'Yann Martel','4j2wo4ip@example.com'),(21,'Pamela Stephenson','tjw31@example.com'),(22,'Dave Pelzer','xbuvd@outlook.com'),(23,'Frank McCourt','4a8yhpu2l@hotmail.com'),(24,'Sebastian Faulks','0vi8ner@outlook.com'),(25,'Philip Pullman','9h4vd96ssc@hotmail.com'),(26,'Kate Mosse','wzsun0@yahoo.com'),(27,'Kathryn Stockett','9035hjp6w@hotmail.com'),(28,'Tony Parsons','sjbt0h@outlook.com'),(29,'Arthur Golden','g0g7ncvh8yyy@hotmail.com'),(30,'Alexander McCall Smith','cqh3i5uj6ex@yahoo.com'),(31,'Victoria Hislop','rowmz3y3dk@hotmail.com'),(32,'Cecelia Ahern','zolat@yahoo.com'),(33,'Gillian McKeith','doztt0r6@example.com'),(34,'Carlos Ruiz Zafon','v4toxo4k4@outlook.com'),(35,'John Grisham','9zs9nzo@outlook.com'),(36,'Robert C. Atkins','wlmf412gmkv@example.com'),(37,'Lynne Truss','vqizdvylf@example.com'),(38,'Delia Smith','gv4bg@outlook.com'),(39,'Joanne Harris','19sw47@outlook.com'),(40,'John Boyne','xcme654um8@example.com'),(41,'Jodi Picoult','ot1opkhbd@gmail.com'),(42,'Harper Lee','0fn0v7sz@outlook.com'),(43,'John Gray','lxmmcqztxi5@gmail.com'),(44,'Dawn French','tuqr3@yahoo.com'),(45,'Marina Lewycka','hptla@outlook.com'),(46,'Thomas Harris','5mgu0f90poc@gmail.com'),(47,'J. R. R. Tolkien','c3tekcw@yahoo.com'),(48,'Michael Moore','yqshd@hotmail.com'),(49,'Jed Rubenfeld','01glz2dw24@hotmail.com'),(50,'Sharon Osbourne','3x6ucyxw458w@hotmail.com'),(51,'Paulo Coelho','xcadc@yahoo.com'),(52,'Paul O\'Grady','w2fsey601@example.com'),(53,'Paul McKenna','a2s94r@yahoo.com'),(54,'Andrea Levy','7i41s@example.com'),(55,'Nigella Lawson','nqfdu@outlook.com'),(56,'Monica Ali','8vvbfucygp@gmail.com'),(57,'Kim Edwards','hgix4dty8sg9@gmail.com'),(58,'Nick Hornby','ajynzjmrpe@example.com'),(59,'Russell Brand','dkw97kl@example.com'),(60,'Richard Dawkins','erxe580x@yahoo.com'),(61,'D.C. Thomson','r6anb98op43s@gmail.com'),(62,'Zadie Smith','fs754zet1ecm@example.com'),(63,'Kate Morton','mgpktadcq@gmail.com'),(64,'Markus Zusak','vrgfc1@gmail.com'),(65,'Maeve Binchy','3tyffqbycv@example.com'),(66,'Robert Harris','m3xyo@gmail.com'),(67,'Suzanne Collins','inzdhavx9wk5@gmail.com');
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
  `release_date` date NOT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `book_ak` (`book_title`,`release_date`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'The Da Vinci Code','While in Paris on business, Harvard symbologist Robert Langdon receives an urgent late-night phone call: the elderly curator of the Louvre has been murdered inside the museum. Near the body, police have found a baffling cipher. While working to solve the enigmatic riddle, Langdon is stunned to discover it leads to a trail of clues hidden in the works of Da Vinci -- clues visible for all to see -- yet ingeniously disguised by the painter. Langdon joins forces with a gifted French cryptologist, Sophie Neveu, and learns the late curator was involved in the Priory of Sion -- an actual secret society whose members included Sir Isaac Newton, Botticelli, Victor Hugo, and Da Vinci, among others. In a breathless race through Paris, London, and beyond, Langdon and Neveu match wits with a faceless powerbroker who seems to anticipate their every move. Unless Langdon and Neveu can decipher the labyrinthine puzzle in time, the Priory\'s ancient secret -- and an explosive historical truth -- will be lost forever. The Da Vinci Code heralds the arrival of a new breed of lightning-paced, intelligent thriller utterly unpredictable right up to its stunning conclusion.','2004-03-01'),(2,'Harry Potter and the Deathly Hallows','','2007-07-21'),(3,'Harry Potter and the Philosopher\'s Stone','','1997-06-26'),(4,'Harry Potter and the Order of the Phoenix','','2003-04-26'),(5,'Fifty Shades of Grey','','2012-04-12'),(6,'Harry Potter and the Goblet of Fire','','2001-03-24'),(7,'Harry Potter and the Chamber of Secrets','','1999-01-02'),(8,'Harry Potter and the Prisoner of Azkaban','','2000-04-01'),(9,'Angels and Demons','','2003-07-01'),(10,'Harry Potter and the Half-blood Prince:Children\'s Edition','','2005-04-09'),(11,'Fifty Shades Darker','','2012-04-26'),(12,'Twilight','','2006-12-09'),(13,'The Girl with the Dragon Tattoo: Millennium Trilogy','','2008-07-24'),(14,'Fifty Shades Freed','','2012-04-26'),(15,'The Lost Symbol','','2009-04-25'),(16,'New Moon','','2007-09-06'),(17,'Deception Point','','2004-05-01'),(18,'Eclipse','','2008-06-27'),(19,'The Lovely Bones','','2003-06-06'),(20,'The Curious Incident of the Dog in the Night-time','','2004-04-01'),(21,'Digital Fortress','','2004-03-05'),(22,'A Short History of Nearly Everything','','2004-06-01'),(23,'The Girl Who Played with Fire: Millennium Trilogy','','2009-07-09'),(24,'Breaking Dawn','','2008-05-24'),(25,'The Very Hungry Caterpillar','','1994-09-29'),(26,'The Gruffalo','','1999-08-21'),(27,'Jamie\'s 30-Minute Meals','','2010-09-30'),(28,'The Kite Runner','','2004-04-17'),(29,'One Day','','2010-02-04'),(30,'A Thousand Splendid Suns','','2007-05-22'),(31,'The Girl Who Kicked the Hornets\' Nest: Millennium Trilogy','','2010-01-23'),(32,'The Time Traveler\'s Wife','','2004-05-29'),(33,'Atonement','','2002-05-02'),(34,'Bridget Jones\'s Diary:A Novel','','1997-06-20'),(35,'The World According to Clarkson','','2005-05-26'),(36,'Captain Corelli\'s Mandolin','','1995-06-01'),(37,'The Sound of Laughter','','2006-10-05'),(38,'Life of Pi','','2003-05-17'),(39,'Billy Connolly','','2002-06-29'),(40,'A Child Called It','','2001-01-04'),(41,'The Gruffalo\'s Child','','2005-09-02'),(42,'Angela\'s Ashes:A Memoir of a Childhood','','1997-05-06'),(43,'Birdsong','','1994-07-18'),(44,'Northern Lights:His Dark Materials S.','','1998-10-23'),(45,'Labyrinth','','2005-07-16'),(46,'Harry Potter and the Half-blood Prince','','2005-04-09'),(47,'The Help','','2010-05-13'),(48,'Man and Boy','','2000-03-06'),(49,'Memoirs of a Geisha','','1998-06-04'),(50,'No.1 Ladies\' Detective Agency','','2003-06-05'),(51,'The Island','','2006-04-10'),(52,'I Love You PS','','2004-03-27'),(53,'You are What You Eat:The Plan That Will Change Your Life','','2004-06-17'),(54,'The Shadow of the Wind','','2005-10-05'),(55,'The Tales of Beedle the Bard','','2008-08-02'),(56,'The Broker','','2005-08-27'),(57,'Dr. Atkins\' New Diet Revolution','','2003-01-02'),(58,'The Subtle Knife','','1998-10-16'),(59,'Eats Shoots and Leaves: The Zero Tolerance Approach to Punctuation','','2003-11-06'),(60,'Delia\'s How to Cook: Book One','','1998-10-12'),(61,'Chocolat','','2000-03-02'),(62,'The Boy in the Striped Pyjamas','','2008-09-11'),(63,'My Sister\'s Keeper','','2004-06-19'),(64,'The Amber Spyglass','','2001-09-14'),(65,'To Kill a Mockingbird','','1989-10-05'),(66,'Men are from Mars, Women are from Venus','','1993-08-01'),(67,'Dear Fatty','','2008-10-09'),(68,'A Short History of Tractors in Ukrainian','','2006-03-02'),(69,'Hannibal','','2000-05-18'),(70,'The Lord of the Rings','','1995-06-05'),(71,'Stupid White Men:...and Other Sorry Excuses for the State of the Nation','','2002-10-03'),(72,'The Interpretation of Murder','','2007-01-15'),(73,'Sharon Osbourne Extreme: My Autobiography','','2005-10-03'),(74,'The Alchemist','','1998-01-03'),(75,'At My Mother\'s Knee ...:and Other Low Joints','','2008-09-24'),(76,'Notes from a Small Island','','1996-08-01'),(77,'The Return of the Naked Chef','','2000-03-30'),(78,'Bridget Jones: The Edge of Reason','','2000-06-15'),(79,'Jamie\'s Italy','','2005-10-03'),(80,'I Can Make You Thin','','2005-01-17'),(81,'Down Under','','2001-05-05'),(82,'The Summons','','2002-09-28'),(83,'Small Island','','2004-09-13'),(84,'Nigella Express','','2007-09-06'),(85,'Brick Lane','','2004-05-01'),(86,'The Memory Keeper\'s Daughter','','2007-04-07'),(87,'Room on the Broom','','2002-09-20'),(88,'About a Boy','','2002-04-04'),(89,'My Booky Wook','','2007-11-15'),(90,'The God Delusion','','2007-05-21'),(91,'The Beano Annual','','2004-09-01'),(92,'White Teeth','','2001-01-25'),(93,'The House at Riverton','','2007-06-15'),(94,'The Book Thief','','2007-09-08'),(95,'Nights of Rain and Stars','','2005-06-29'),(96,'The Ghost','','2008-07-03'),(97,'Happy Days with the Naked Chef','','2001-09-03'),(98,'The Hunger Games','','2011-12-01'),(99,'The Lost Boy: A Foster Child\'s Search for the Love of a Family','','2001-04-07'),(100,'Jamie\'s Ministry of Food: Anyone Can Learn to Cook in 24 Hours','','2008-10-03');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_author`
--

DROP TABLE IF EXISTS `book_author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_author` (
  `book_id` int NOT NULL,
  `author_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`author_id`),
  KEY `book_author_fk_author` (`author_id`),
  CONSTRAINT `book_author_fk_author` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `book_author_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_author`
--

LOCK TABLES `book_author` WRITE;
/*!40000 ALTER TABLE `book_author` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_format`
--

DROP TABLE IF EXISTS `book_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_format` (
  `book_id` int NOT NULL,
  `format_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`format_id`),
  KEY `book_format_fk_format` (`format_id`),
  CONSTRAINT `book_format_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_format_fk_format` FOREIGN KEY (`format_id`) REFERENCES `format` (`format_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_format`
--

LOCK TABLES `book_format` WRITE;
/*!40000 ALTER TABLE `book_format` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre`
--

DROP TABLE IF EXISTS `book_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genre` (
  `book_id` int NOT NULL,
  `genre_name` varchar(32) NOT NULL,
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
  PRIMARY KEY (`list_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_list`
--

LOCK TABLES `book_list` WRITE;
/*!40000 ALTER TABLE `book_list` DISABLE KEYS */;
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
  `book_id` int NOT NULL,
  PRIMARY KEY (`book_list_name`,`book_id`),
  KEY `book_list_book_fk_book` (`book_id`),
  CONSTRAINT `book_list_book_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_list_book_fk_book_list` FOREIGN KEY (`book_list_name`) REFERENCES `book_list` (`list_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_list_book`
--

LOCK TABLES `book_list_book` WRITE;
/*!40000 ALTER TABLE `book_list_book` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_list_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_publisher`
--

DROP TABLE IF EXISTS `book_publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_publisher` (
  `book_id` int NOT NULL,
  `publisher_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`publisher_id`),
  KEY `book_publisher_fk_publisher` (`publisher_id`),
  CONSTRAINT `book_publisher_fk_book` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_publisher_fk_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `publisher` (`publisher_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_publisher`
--

LOCK TABLES `book_publisher` WRITE;
/*!40000 ALTER TABLE `book_publisher` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_publisher` ENABLE KEYS */;
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
/*!40000 ALTER TABLE `book_series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `format`
--

DROP TABLE IF EXISTS `format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `format` (
  `format_id` int NOT NULL AUTO_INCREMENT,
  `format_type` enum('Hard Cover','Paper Back','PDF','eBook','Audio Book') NOT NULL,
  `url` varchar(512) NOT NULL,
  PRIMARY KEY (`format_id`),
  UNIQUE KEY `format_ak` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `format`
--

LOCK TABLES `format` WRITE;
/*!40000 ALTER TABLE `format` DISABLE KEYS */;
/*!40000 ALTER TABLE `format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genre_name` varchar(32) NOT NULL,
  PRIMARY KEY (`genre_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES ('Adventure'),('Contemporary Fiction'),('Cozy Mystery'),('Crime Fiction'),('Dark Fantasy'),('Detective Fiction'),('Dystopian'),('Epic Fantasy'),('Fantasy'),('Gothic Fiction'),('Historical Fiction'),('Historical Romance'),('Horror'),('Legal Thriller'),('Literary Fiction'),('Magical Realism'),('Mystery'),('New Adult'),('Paranormal Romance'),('Political Thriller'),('Post-Apocalyptic'),('Psychological Thriller'),('Romance'),('Science Fiction'),('Space Opera'),('Steampunk'),('Thriller'),('Time Travel Fiction'),('Urban Fantasy'),('Young Adult');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'publisher_name','email_address'),(2,'Transworld Grp','a8xonwb21@example.com'),(3,'Bloomsbury Grp','h24bp3uuzesr@hotmail.com'),(4,'Random House Grp','1t44nheuc@yahoo.com'),(5,'Little, Brown Book Grp','evec1mn@example.com'),(6,'Quercus Grp','rmbh2or@yahoo.com'),(7,'Pan Macmillan Grp','hh7uxmx76k7@hotmail.com'),(8,'Penguin Grp','d5bcmg8xt1@yahoo.com'),(9,'Hodder & Stoughton Grp','rjxe0s@outlook.com'),(10,'Canongate Grp','7nw4358h@outlook.com'),(11,'HarperCollins Grp','f6io75wp@example.com'),(12,'Orion Grp','hogo3oa@gmail.com'),(13,'Scholastic Ltd. Grp','8yi1o33h04hy@outlook.com'),(14,'Headline Grp','pdqbblnanxy@hotmail.com'),(15,'Profile Books Group','rpxj7nqi6zw@yahoo.com'),(16,'Random House Childrens Books G','i5y0r92c5x0d@outlook.com'),(17,'D.C. Thomson','85bsscd4d6o@outlook.com');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `series`
--

LOCK TABLES `series` WRITE;
/*!40000 ALTER TABLE `series` DISABLE KEYS */;
INSERT INTO `series` VALUES (3,'Harry Potter'),(5,'Millenium Trilogy'),(1,'The Hunger Games'),(2,'Twilight');
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

--
-- Table structure for table `user_book_list`
--

DROP TABLE IF EXISTS `user_book_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_book_list` (
  `user_name` varchar(64) NOT NULL,
  `book_list_name` varchar(64) NOT NULL,
  PRIMARY KEY (`user_name`,`book_list_name`),
  KEY `user_book_list_fk_book_list` (`book_list_name`),
  CONSTRAINT `user_book_list_fk_book_list` FOREIGN KEY (`book_list_name`) REFERENCES `book_list` (`list_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_book_list_fk_user` FOREIGN KEY (`user_name`) REFERENCES `user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_book_list`
--

LOCK TABLES `user_book_list` WRITE;
/*!40000 ALTER TABLE `user_book_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_book_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_book_rating`
--

DROP TABLE IF EXISTS `user_book_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_book_rating` (
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
-- Dumping data for table `user_book_rating`
--

LOCK TABLES `user_book_rating` WRITE;
/*!40000 ALTER TABLE `user_book_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_book_rating` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-26 18:08:49
