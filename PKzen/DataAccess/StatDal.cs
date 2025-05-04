using PKzen.Models;

namespace PKzen.DataAccess
{
    public class StatDal : RepositoryBase<Stat>
    {
        private const string TABLE = "Stat";

        public override Stat GetById(int id)
            => QuerySingle<Stat>($"SELECT Id, Name FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<Stat> GetAll()
            => Query<Stat>($"SELECT * FROM {TABLE}");
    }
}
