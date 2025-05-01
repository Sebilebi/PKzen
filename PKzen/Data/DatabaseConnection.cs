using Microsoft.Data.Sqlite;

namespace PKzen.Data
{
    public sealed class DatabaseConnection
    {
        private static readonly Lazy<DatabaseConnection> _instance = new(() => new DatabaseConnection());
        private readonly SqliteConnection _connection;

        private DatabaseConnection()
        {
            // Ruta de la base de datos SQLite
            var connectionString = "Data Source=C:\\Users\\sebilebi\\Source\\Repos\\PKzen\\PKzen\\Resources\\PKzenDB;Mode=ReadWriteCreate;Foreign Keys=True;";
            _connection = new SqliteConnection(connectionString);
            _connection.Open();
        }

        public static DatabaseConnection Instance => _instance.Value;

        public SqliteConnection GetConnection() => _connection;

        ~DatabaseConnection()
        {
            _connection?.Dispose();
        }
    }
}
