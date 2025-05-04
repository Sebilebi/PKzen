using PKzen.Models;

namespace PKzen.DataAccess
{
    public class AbilityDal : RepositoryBase<Ability>
    {
        private const string TABLE = "Ability";

        public override Ability GetById(int id)
            => QuerySingle<Ability>($"SELECT Id, Name, Description, IsHidden FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<Ability> GetAll()
            => Query<Ability>($"SELECT * FROM {TABLE}");
    }
}
