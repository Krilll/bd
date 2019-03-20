-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Мар 20 2019 г., 18:25
-- Версия сервера: 8.0.12
-- Версия PHP: 7.1.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `bd`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `find_man` (`name` VARCHAR(25), `lastname` VARCHAR(30))  BEGIN
SELECT `workers`.`name`, `workers`.`lastname`, 
`workers`.`salary`,`workers`.`position`, `departments`.`name` AS department
FROM `workers` JOIN `departments` 
ON `workers`.`department` = `departments`.`id`
WHERE `workers`.`name` = name AND `workers`.`lastname` = lastname;
END$$

--
-- Функции
--
CREATE DEFINER=`root`@`%` FUNCTION `find_man` (`name` VARCHAR(25), `lastname` VARCHAR(30)) RETURNS VARCHAR(25) CHARSET utf8 READS SQL DATA
    DETERMINISTIC
RETURN (SELECT `workers`.`id` FROM `workers` 
WHERE `workers`.`name` = name AND `workers`.`lastname` = lastname)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `cities`
--

CREATE TABLE `cities` (
  `region_id` int(1) NOT NULL,
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `important` tinyint(1) NOT NULL,
  `country_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `cities`
--

INSERT INTO `cities` (`region_id`, `id`, `title`, `important`, `country_id`) VALUES
(1, 1, 'Санкт-Петербург', 1, 1),
(1, 2, 'Тосно', 0, 1),
(2, 3, 'Москва', 1, 1),
(2, 4, 'Можайск', 0, 1);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `city_info`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `city_info` (
`city` varchar(150)
,`region` varchar(150)
,`country` varchar(150)
,`ci_id` int(11)
,`co_id` int(11)
,`ci_reg_id` int(1)
,`reg_id` int(11)
);

-- --------------------------------------------------------

--
-- Структура таблицы `countries`
--

CREATE TABLE `countries` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `countries`
--

INSERT INTO `countries` (`id`, `title`) VALUES
(2, 'Австралия'),
(3, 'Великобритания'),
(1, 'Россия');

-- --------------------------------------------------------

--
-- Структура таблицы `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `count` int(11) DEFAULT '0',
  `head_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `departments`
--

INSERT INTO `departments` (`id`, `name`, `count`, `head_id`) VALUES
(1, 'IT', 0, NULL),
(2, 'Бухгалтерия', 0, NULL),
(3, 'ИБ', 0, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `regions`
--

CREATE TABLE `regions` (
  `country_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `regions`
--

INSERT INTO `regions` (`country_id`, `id`, `title`) VALUES
(1, 1, 'Ленинградская область'),
(1, 2, 'Московская область'),
(3, 3, 'Англия'),
(3, 4, 'Шотландия');

-- --------------------------------------------------------

--
-- Структура таблицы `salary`
--

CREATE TABLE `salary` (
  `id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `salary` int(11) NOT NULL,
  `bonus` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `salary`
--

INSERT INTO `salary` (`id`, `worker_id`, `salary`, `bonus`) VALUES
(1, 2, 30000, 1000),
(2, 13, 25000, 1000),
(3, 14, 27000, 1000);

-- --------------------------------------------------------

--
-- Структура таблицы `workers`
--

CREATE TABLE `workers` (
  `id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `department` int(11) NOT NULL,
  `salary` int(11) NOT NULL,
  `position` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `workers`
--

INSERT INTO `workers` (`id`, `name`, `lastname`, `department`, `salary`, `position`) VALUES
(1, 'Юрий', 'Карась', 2, 10000, NULL),
(2, 'Анастасия', 'Белая', 2, 30000, NULL),
(3, 'Екатерина', 'Неустроева', 1, 20000, NULL),
(4, 'Алина', 'Таранина', 1, 30000, NULL),
(5, 'Анна', 'Бахмет', 3, 15000, NULL),
(6, 'Анастасия', 'Малащицкая', 3, 16000, NULL),
(13, 'Андрей', 'Краснов', 3, 25000, NULL),
(14, 'Павел', 'Якимов', 1, 27000, NULL);

--
-- Триггеры `workers`
--
DELIMITER $$
CREATE TRIGGER `bonus` AFTER INSERT ON `workers` FOR EACH ROW INSERT INTO `salary` (`worker_id`, `salary`, `bonus`) VALUES (NEW.id, NEW.salary, 1000)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура для представления `city_info`
--
DROP TABLE IF EXISTS `city_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `city_info`  AS  select `cities`.`title` AS `city`,`regions`.`title` AS `region`,`countries`.`title` AS `country`,`cities`.`country_id` AS `ci_id`,`countries`.`id` AS `co_id`,`cities`.`region_id` AS `ci_reg_id`,`regions`.`id` AS `reg_id` from ((`cities` join `regions`) join `countries`) having ((`ci_id` = `co_id`) and (`ci_reg_id` = `reg_id`)) ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `country_id` (`country_id`),
  ADD KEY `region_id` (`region_id`);

--
-- Индексы таблицы `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Индексы таблицы `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `regions`
--
ALTER TABLE `regions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `title` (`title`),
  ADD KEY `country_id` (`country_id`);

--
-- Индексы таблицы `salary`
--
ALTER TABLE `salary`
  ADD PRIMARY KEY (`id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- Индексы таблицы `workers`
--
ALTER TABLE `workers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `department` (`department`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cities`
--
ALTER TABLE `cities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `regions`
--
ALTER TABLE `regions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `salary`
--
ALTER TABLE `salary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `workers`
--
ALTER TABLE `workers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cities_ibfk_2` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `regions`
--
ALTER TABLE `regions`
  ADD CONSTRAINT `regions_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `salary`
--
ALTER TABLE `salary`
  ADD CONSTRAINT `salary_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `workers`
--
ALTER TABLE `workers`
  ADD CONSTRAINT `workers_ibfk_1` FOREIGN KEY (`department`) REFERENCES `departments` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
