using Dapper;
using Microsoft.Data.Sqlite;
using PKzen.Data;

namespace PKzen.DataAccess
{
    public abstract class RepositoryBase<T> : IRepository<T>
    {
        protected readonly SqliteConnection Conn = Database.Instance.Connection;

        public abstract T GetById(int id);
        public abstract IEnumerable<T> GetAll();

        protected IEnumerable<TModel> Query<TModel>(string sql, object? param = null)
            => Conn.Query<TModel>(sql, param);

        protected TModel? QuerySingle<TModel>(string sql, object param)
            => Conn.QuerySingleOrDefault<TModel>(sql, param);
    }
}
