-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 28, 2024 at 06:43 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `audit-plan`
--

-- --------------------------------------------------------

--
-- Table structure for table `main_areas`
--

CREATE TABLE `main_areas` (
  `id` int(11) NOT NULL,
  `main_area` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL,
  `specific_area_id` int(11) DEFAULT NULL,
  `question_number` int(11) DEFAULT NULL,
  `question` text DEFAULT NULL,
  `question_tamil` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `specific_areas`
--

CREATE TABLE `specific_areas` (
  `id` int(11) NOT NULL,
  `main_area_id` int(11) DEFAULT NULL,
  `area_specific` varchar(255) NOT NULL,
  `area_specific_tamil` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `specific_task_report`
--

CREATE TABLE `specific_task_report` (
  `id` int(11) NOT NULL,
  `week_number` int(11) NOT NULL,
  `month` varchar(20) NOT NULL,
  `year` int(11) NOT NULL,
  `task_id` varchar(255) NOT NULL,
  `audit_date` date NOT NULL,
  `main_area` varchar(255) DEFAULT NULL,
  `specific_area` varchar(255) DEFAULT NULL,
  `report_observation` text DEFAULT NULL,
  `specific_task_id` varchar(255) DEFAULT NULL,
  `action_taken` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int(11) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `phoneNumber` bigint(11) NOT NULL,
  `staffId` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `firstName`, `lastName`, `phoneNumber`, `staffId`, `created_at`) VALUES
(1, 'kishore', '$2a$10$CE.YEZ9Yg0ZH/ctmnbbmMuVqL5NiRfWo0KzmrKk7ZENFIKmFwlFpa', 1, 'Kishore', 'R', 324242, 'IN7392', '2024-08-21 03:40:33'),
(22, 'vijay', '$2a$10$LgkXtPbiZYO.fjcte/09uebQW8rJMmsfn/O4MGCpD1rc44mrq7CPy', 1, 'vijay', 'vijay', 123456789, 'vijay123', '2024-07-15 14:22:26'),
(35, 'psbitsathy', '$2b$10$CdbP1r10SPdri8Nuy5q/uuRZBVf4POHYvQWED1Q7FWJeuS/0Mmtde', 1, 'ps', 'bitsathy', 123456789, 'psbitsathy123', '2024-08-28 04:42:20');

-- --------------------------------------------------------

--
-- Table structure for table `user_role`
--

CREATE TABLE `user_role` (
  `id` int(11) NOT NULL,
  `role` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_role`
--

INSERT INTO `user_role` (`id`, `role`) VALUES
(1, 'admin'),
(2, 'user'),
(3, 'executer');

-- --------------------------------------------------------

--
-- Table structure for table `user_tokens`
--

CREATE TABLE `user_tokens` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `fcmtoken` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_tokens`
--

INSERT INTO `user_tokens` (`id`, `username`, `fcmtoken`, `created_at`, `updated_at`) VALUES
(23, 'vijay', 'cCsfdlhxR02zphkILU-jt1:APA91bGbY62MBxjON8kQVw90fG49GrhzFyT5FRt-JHIAMCqDZGUbnkLTj-bbd8TGqjZpPIq8rhhsozkUWGMFoHW_bjD5WWiV4ZiGM3u1-ChXb3vz3yTlQdakCXRS5Ou0HwvzNcdEFxgy', '2024-08-27 19:26:05', '2024-08-27 19:26:05'),
(28, 'vijay', 'csFZhgXURBKhM043Y6BH2n:APA91bHaH2CW9Yq9hIzIZCRvl67hbsDneP6iK3FG_arqHE-ThZxRp6n68qQJ-OVGH62k3a8AgnDfgeIe_3SYlU9ukiopImIYPT1z3MVvEfCc5mTKz6dRQRHSdfCJAmYKQKRW1rmiiF69', '2024-08-28 04:22:28', '2024-08-28 04:22:28');

-- --------------------------------------------------------

--
-- Table structure for table `weekly_audits`
--

CREATE TABLE `weekly_audits` (
  `id` int(11) NOT NULL,
  `main_area` varchar(255) DEFAULT NULL,
  `specific_area` varchar(255) DEFAULT NULL,
  `task_id` varchar(255) DEFAULT NULL,
  `audit_date` date DEFAULT NULL,
  `week_number` int(11) NOT NULL,
  `month` varchar(255) NOT NULL,
  `year` int(11) NOT NULL,
  `auditor_name` varchar(255) DEFAULT NULL,
  `auditor_phone` varchar(20) DEFAULT NULL,
  `suggestions` varchar(255) NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weekly_audit_assign`
--

CREATE TABLE `weekly_audit_assign` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `weekly_taskId` varchar(255) NOT NULL,
  `week_number` int(11) NOT NULL,
  `month` varchar(255) NOT NULL,
  `year` int(11) NOT NULL,
  `selected_area` varchar(255) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weekly_audit_details`
--

CREATE TABLE `weekly_audit_details` (
  `id` int(11) NOT NULL,
  `audit_id` int(11) DEFAULT NULL,
  `question_number` int(11) DEFAULT NULL,
  `question` text DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `comment` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weekly_tasks`
--

CREATE TABLE `weekly_tasks` (
  `weekTask_id` int(11) NOT NULL,
  `weekly_taskId` varchar(255) NOT NULL,
  `weekNumber` int(11) NOT NULL,
  `month` varchar(255) NOT NULL,
  `year` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `main_areas`
--
ALTER TABLE `main_areas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `specific_area_id` (`specific_area_id`);

--
-- Indexes for table `specific_areas`
--
ALTER TABLE `specific_areas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `main_area_id` (`main_area_id`);

--
-- Indexes for table `specific_task_report`
--
ALTER TABLE `specific_task_report`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role` (`role`);

--
-- Indexes for table `user_role`
--
ALTER TABLE `user_role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `weekly_audits`
--
ALTER TABLE `weekly_audits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weekly_audit_assign`
--
ALTER TABLE `weekly_audit_assign`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weekly_audit_details`
--
ALTER TABLE `weekly_audit_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_id` (`audit_id`);

--
-- Indexes for table `weekly_tasks`
--
ALTER TABLE `weekly_tasks`
  ADD PRIMARY KEY (`weekTask_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `main_areas`
--
ALTER TABLE `main_areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `specific_areas`
--
ALTER TABLE `specific_areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `specific_task_report`
--
ALTER TABLE `specific_task_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `user_role`
--
ALTER TABLE `user_role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_tokens`
--
ALTER TABLE `user_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `weekly_audits`
--
ALTER TABLE `weekly_audits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `weekly_audit_assign`
--
ALTER TABLE `weekly_audit_assign`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `weekly_audit_details`
--
ALTER TABLE `weekly_audit_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `weekly_tasks`
--
ALTER TABLE `weekly_tasks`
  MODIFY `weekTask_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `specific_areas`
--
ALTER TABLE `specific_areas`
  ADD CONSTRAINT `specific_areas_ibfk_1` FOREIGN KEY (`main_area_id`) REFERENCES `main_areas` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role`) REFERENCES `user_role` (`id`);

--
-- Constraints for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
