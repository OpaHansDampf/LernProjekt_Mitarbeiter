using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Text.Json;

namespace GUI_MitarbeiterVerwaltung_test.DB
{

    public class DbHelper
    {
        private string _connectionString;
        private DbHelper()
        {
            _connectionString = LoadConnectionString();
        }

        private string LoadConnectionString()
        {
            var configPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "dbconfig.json");
            if (!File.Exists(configPath))
            {
                MessageBox.Show("Keine Konfigurationsdatei gefunden!");
                return "";
            }

            var jsonString = File.ReadAllText(configPath);
            var config = JsonSerializer.Deserialize<DatabaseConfig>(jsonString);

            var builder = new SqlConnectionStringBuilder
            {
                DataSource = config.DatabaseSettings.Server,
                InitialCatalog = config.DatabaseSettings.Database,
                IntegratedSecurity = config.DatabaseSettings.IntegratedSecurity,
                TrustServerCertificate = config.DatabaseSettings.TrustServerCertificate
            };

            if (!config.DatabaseSettings.IntegratedSecurity)
            {
                builder.UserID = config.DatabaseSettings.Username;
                builder.Password = config.DatabaseSettings.Password;
            }

            return builder.ToString();
        }

        public class DatabaseConfig
        {
            public DatabaseSettings DatabaseSettings { get; set; }
        }

        public class DatabaseSettings
        {
            public string Server { get; set; }
            public string Database { get; set; }
            public string Username { get; set; }
            public string Password { get; set; }
            public bool IntegratedSecurity { get; set; }
            public bool TrustServerCertificate { get; set; }
        }
        private static DbHelper _instance;
        public static DbHelper GetDb()
        {
            if (_instance == null)
            {
                _instance = new DbHelper();
            }
            return _instance;
        }






        // Einfache Version für SELECT
        public DataTable SqlGetData(string sqlBefehl)
        {
            DataTable ergebnis = new DataTable();
            SqlConnection verbindung = null;
            try
            {
                verbindung = new SqlConnection(_connectionString);
                SqlCommand command = new SqlCommand(sqlBefehl, verbindung);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                verbindung.Open();
                adapter.Fill(ergebnis);
                return ergebnis;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Datenbankfehler: {ex.Message}");
                return null;
            }
            finally
            {
                if (verbindung != null)
                {
                    verbindung.Close();
                    verbindung.Dispose();
                }
            }
        }

        // Version mit Parametern für SELECT
        public DataTable SqlGetData(string sqlBefehl, params SqlParameter[] parameters)
        {
            DataTable ergebnis = new DataTable();
            SqlConnection verbindung = null;
            try
            {
                verbindung = new SqlConnection(_connectionString);
                SqlCommand command = new SqlCommand(sqlBefehl, verbindung);
                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters);
                }
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                verbindung.Open();
                adapter.Fill(ergebnis);
                return ergebnis;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Datenbankfehler: {ex.Message}");
                return null;
            }
            finally
            {
                if (verbindung != null)
                {
                    verbindung.Close();
                    verbindung.Dispose();
                }
            }
        }

        // Einfache Version für INSERT, UPDATE, DELETE
        public int SqlSetData(string sqlBefehl)
        {
            SqlConnection verbindung = null;
            try
            {
                verbindung = new SqlConnection(_connectionString);
                SqlCommand command = new SqlCommand(sqlBefehl, verbindung);
                verbindung.Open();
                return command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Datenbankfehler: {ex.Message}");
                return -1;
            }
            finally
            {
                if (verbindung != null)
                {
                    verbindung.Close();
                    verbindung.Dispose();
                }
            }
        }

        // Version mit Parametern für INSERT, UPDATE, DELETE
        public int SqlSetData(string sqlBefehl, params SqlParameter[] parameters)
        {
            SqlConnection verbindung = null;
            try
            {
                verbindung = new SqlConnection(_connectionString);
                SqlCommand command = new SqlCommand(sqlBefehl, verbindung);
                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters);
                }
                verbindung.Open();
                return command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Datenbankfehler: {ex.Message}");
                return -1;
            }
            finally
            {
                if (verbindung != null)
                {
                    verbindung.Close();
                    verbindung.Dispose();
                }
            }
        }
    }
}