using PKzen.Models;

namespace PKzen.DataAccess
{
    public class CriesDal : RepositoryBase<Cries>
    {
        private const string TABLE = "Cries";

        public override Cries GetById(int id)
            => QuerySingle<Cries>($"SELECT * FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<Cries> GetAll()
            => Query<Cries>($"SELECT * FROM {TABLE}");

        public IEnumerable<Cries> GetBySpeciesId(int speciesId)
            => Query<Cries>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });
    }
}
