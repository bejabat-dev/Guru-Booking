-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 09, 2024 at 11:54 PM
-- Server version: 8.0.37-0ubuntu0.22.04.3
-- PHP Version: 8.1.2-1ubuntu2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `guru_booking`
--

-- --------------------------------------------------------

--
-- Table structure for table `Booking`
--

CREATE TABLE `Booking` (
  `id` int NOT NULL,
  `id_siswa` int NOT NULL,
  `id_guru` int NOT NULL,
  `mata_pelajaran` varchar(20) NOT NULL,
  `tanggal` varchar(256) NOT NULL,
  `status` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Booking`
--

INSERT INTO `Booking` (`id`, `id_siswa`, `id_guru`, `mata_pelajaran`, `tanggal`, `status`) VALUES
(1, 23, 27, '', 'tanggal', 'Selesai'),
(2, 23, 27, 'Matematika', 'tanggal', 'Selesai'),
(3, 23, 26, 'Matematika', 'tanggal', 'Selesai'),
(4, 23, 29, 'Bahasa Inggris', 'tanggal', 'Selesai'),
(5, 23, 26, 'Matematika', 'tanggal', 'Selesai'),
(6, 23, 26, 'Matematika', 'tanggal', 'Selesai'),
(7, 23, 26, 'Matematika', 'tanggal', 'Selesai');

-- --------------------------------------------------------

--
-- Table structure for table `Jadwal`
--

CREATE TABLE `Jadwal` (
  `id` int NOT NULL,
  `id_siswa` int NOT NULL,
  `id_guru` int NOT NULL,
  `nama_siswa` varchar(256) NOT NULL,
  `nama_guru` varchar(100) NOT NULL,
  `mata_pelajaran` varchar(24) NOT NULL,
  `tarif` int NOT NULL,
  `tanggal` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Jadwal`
--

INSERT INTO `Jadwal` (`id`, `id_siswa`, `id_guru`, `nama_siswa`, `nama_guru`, `mata_pelajaran`, `tarif`, `tanggal`, `status`) VALUES
(10, 32, 27, 'Siswa', 'Soepomo', 'Matematika', 250000, 'tanggal', 'Booking diterima'),
(11, 23, 27, 'Muhamad Novan Alfarisi', 'Soepomo', 'Matematika', 250000, 'tanggal', 'Booking diterima'),
(12, 23, 27, 'Muhamad Novan Alfarisi', 'Soepomo', 'Matematika', 250000, 'tanggal', 'Booking diterima'),
(13, 23, 26, 'Muhamad Novan Alfarisi', 'Drs. Soeharto', 'Matematika', 250000, 'tanggal', 'Booking diterima'),
(14, 23, 29, 'Muhamad Novan Alfarisi', 'Haikal', 'Bahasa Inggris', 125000, 'tanggal', 'Booking diterima');

-- --------------------------------------------------------

--
-- Table structure for table `Mata_Pelajaran`
--

CREATE TABLE `Mata_Pelajaran` (
  `id` int NOT NULL,
  `deskripsi` varchar(45) NOT NULL,
  `tarif` int NOT NULL,
  `icon` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Mata_Pelajaran`
--

INSERT INTO `Mata_Pelajaran` (`id`, `deskripsi`, `tarif`, `icon`) VALUES
(8, 'Matematika', 250000, 'http://localhost:3000/uploads/1720427021649.png'),
(9, 'Bahasa Inggris', 125000, 'http://localhost:3000/uploads/1720427048906.png');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `id` int NOT NULL,
  `mata_pelajaran` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Belum disetel',
  `nama` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` text NOT NULL,
  `password` varchar(64) NOT NULL,
  `nohp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Belum disetel',
  `kualifikasi` int DEFAULT NULL,
  `alamat` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Belum disetel',
  `foto_profil` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`id`, `mata_pelajaran`, `nama`, `email`, `role`, `password`, `nohp`, `kualifikasi`, `alamat`, `foto_profil`) VALUES
(23, 'Belum disetel', 'Muhamad Novan Alfarisi', 'noobplayer1255@gmail.com', 'siswa', '$2b$10$C60pitxFwlXDOdgYZKvWVe44/O0Ozv/q6QWpZfArOqbEm0YEOSDb6', '085376777244', NULL, 'Bengkong Kolam No 39', 'http://localhost:3000/uploads/1720115487625.jpg'),
(26, 'Matematika', 'Drs. Soeharto', 'noobplayer1254@gmail.com', 'guru', '$2b$10$Ym3aaP8o4zuc6MPIvHPKQelnTZFK7IJXBzTG8RGEjYMNTYfzRdgby', '0853767772231', NULL, 'Bengkong Kodim', 'http://localhost:3000/uploads/1720001635101.png'),
(27, 'Matematika', 'Soepomo', 'noobplayer1253@gmail.com', 'guru', '$2b$10$ppLnyfXPyuOrwZeBK1JdvOjBGMSKs59MpxSOPkFHs/QyrDJA4Gm76', '0856666', NULL, 'Jl. Jenderal Sudirman', 'http://localhost:3000/uploads/1719956413219.png'),
(28, 'Belum disetel', 'Admin', 'admin', 'admin', '$2b$10$yUAWna69qTDltIBK7NKWnexXZ04W1F3M.y/lznHsRsju3zy1SxdNi', 'Belum disetel', NULL, 'Belum disetel', 'http://localhost:3000/uploads/1720426055354.png'),
(29, 'Bahasa Inggris', 'Haikal', 'haikal', 'guru', '$2b$10$BSZW7oZ17u9ZXYTEKJZEfuihW7oIKp9u5LDp6ouXc96ge86RcXPd.', '081321312s', NULL, 'Bandara Juanda s', ''),
(30, 'Belum disetel', 'Gue', 'gue', 'siswa', '$2b$10$J5eptLZGMCCDzUVpJwYTpuMnf/n6hZnSSYkVjSMg6IMeA7jVJs8gW', 'Belum disetel', NULL, 'Belum disetel', ''),
(31, 'Belum disetel', 'Guru', 'guru', 'guru', '$2b$10$iDmT.e8PZneMGE.5kx1f3esKURsq5sf9ax4ekDkfDhplvwXup19uW', 'Belum disetel', NULL, 'Belum disetel', ''),
(32, 'Belum disetel', 'Siswa', 'siswa', 'siswa', '$2b$10$9hofbLVgj4aKw3yLyKJrOOj1iiU1DZ5AbISbpUlkNfzR4VBVn1MRS', '086712312', NULL, 'Jakartaaa', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Booking`
--
ALTER TABLE `Booking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Jadwal`
--
ALTER TABLE `Jadwal`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Mata_Pelajaran`
--
ALTER TABLE `Mata_Pelajaran`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Booking`
--
ALTER TABLE `Booking`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Jadwal`
--
ALTER TABLE `Jadwal`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `Mata_Pelajaran`
--
ALTER TABLE `Mata_Pelajaran`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
