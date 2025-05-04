using PKzen.Models;

namespace PKzen.DataAccess
{
    public class EggGroupDal : RepositoryBase<EggGroup>
    {
        private const string TABLE = "EggGroup";

        public override EggGroup GetById(int id)
            => QuerySingle<EggGroup>($"SELECT Id, Name FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<EggGroup> GetAll()
            => Query<EggGroup>($"SELECT * FROM {TABLE}");
    }
}
