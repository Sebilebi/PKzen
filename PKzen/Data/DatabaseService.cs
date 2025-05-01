using Microsoft.Data.Sqlite;

namespace PKzen.Data
{
    public class DatabaseService
    {
        private static readonly Lazy<DatabaseService> _instance = new(() => new DatabaseService());
        private readonly SqliteConnection _connection;

        private DatabaseService()
        {
            _connection = DatabaseConnection.Instance.GetConnection();
        }

        public static DatabaseService Instance => _instance.Value;

        public List<T> ExecuteQuery<T>(string query, Func<SqliteDataReader, T> mapFunction)
        {
            var results = new List<T>();

            using var command = new SqliteCommand(query, _connection);
            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                results.Add(mapFunction(reader));
            }

            return results;
        }

        public int ExecuteNonQuery(string query)
        {
            using var command = new SqliteCommand(query, _connection);
            return command.ExecuteNonQuery();
        }

        public T ExecuteScalar<T>(string query)
        {
            using var command = new SqliteCommand(query, _connection);
            return (T)command.ExecuteScalar();
        }
    }
}
