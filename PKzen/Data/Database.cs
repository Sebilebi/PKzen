using Microsoft.Data.Sqlite;

namespace PKzen.Data
{
    public sealed class Database
    {
        private const string CONNECTION_STRING = "Data Source=pokemon.db";
        private static readonly Lazy<Database> _instance = new(() => new Database());
        private readonly SqliteConnection _connection;

        private Database()
        {
            _connection = new SqliteConnection(CONNECTION_STRING);
            _connection.Open();
        }

        public static Database Instance => _instance.Value;

        public SqliteConnection Connection => _connection;
    }
}
