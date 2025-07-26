#!/usr/bin/env Rscript

# ---------------------------
# FILE HASHER (R VERSION)
# ---------------------------

suppressPackageStartupMessages({
  library(digest)
  library(jsonlite)
  library(tools)
})

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: Rscript file_hasher.R <path_to_file_or_directory_or_archive>")
}

target_path <- normalizePath(args[1], mustWork = FALSE)

if (!file.exists(target_path)) {
  stop("❌ File or directory does not exist.")
}

hash_file <- function(file_path) {
  con <- file(file_path, "rb")
  hash <- digest(con, algo = "sha256", file = TRUE)
  close(con)
  return(hash)
}

hash_directory <- function(dir_path) {
  files <- list.files(dir_path, recursive = TRUE, full.names = TRUE)
  hashes <- sapply(files, function(f) {
    if (file_test("-f", f)) {
      tryCatch(hash_file(f), error = function(e) NA)
    } else {
      NA
    }
  }, USE.NAMES = TRUE)
  return(hashes)
}

extract_and_hash_zip <- function(zip_path) {
  temp_dir <- tempfile(pattern = "unzip_")
  dir.create(temp_dir)
  unzip(zip_path, exdir = temp_dir)
  result <- hash_directory(temp_dir)
  unlink(temp_dir, recursive = TRUE)
  return(result)
}

extract_and_hash_rar <- function(rar_path) {
  temp_dir <- tempfile(pattern = "unrar_")
  dir.create(temp_dir)
  command <- sprintf('unrar x -inul "%s" "%s"', rar_path, temp_dir)
  system(command, ignore.stdout = TRUE, ignore.stderr = TRUE)
  result <- hash_directory(temp_dir)
  unlink(temp_dir, recursive = TRUE)
  return(result)
}

result <- list()

if (file_test("-d", target_path)) {
  result <- hash_directory(target_path)
} else {
  ext <- tolower(file_ext(target_path))
  if (ext == "zip") {
    result <- extract_and_hash_zip(target_path)
  } else if (ext == "rar") {
    result <- extract_and_hash_rar(target_path)
  } else {
    result <- c(target_path = hash_file(target_path))
  }
}

cat(toJSON(result, pretty = TRUE, auto_unbox = TRUE))
