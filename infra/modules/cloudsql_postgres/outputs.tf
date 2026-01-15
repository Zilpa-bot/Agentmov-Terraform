output "instance_connection_name" {
  value = google_sql_database_instance.pg.connection_name
}

output "private_ip" {
  value = google_sql_database_instance.pg.private_ip_address
}

output "db_name" {
  value = google_sql_database.appdb.name
}

output "db_user" {
  value = google_sql_user.app.name
}

output "db_password_secret_id" {
  value = google_secret_manager_secret.app_user_password.id
}
