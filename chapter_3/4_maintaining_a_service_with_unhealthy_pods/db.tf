resource "google_sql_database_instance" "master" {
  name             = "${var.lab_name}-test-db"
  database_version = "MYSQL_5_7"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "myapp"
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "users" {
  name     = "myapp"
  instance = google_sql_database_instance.master.name
  password = "password"
}