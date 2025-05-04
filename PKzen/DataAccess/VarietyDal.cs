using PKzen.Models;

namespace PKzen.DataAccess
{
    public class VarietyDal : RepositoryBase<Variety>
    {
        private const string TABLE = "Variety";

        public override Variety GetById(int id)
            => QuerySingle<Variety>($"SELECT * FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<Variety> GetAll()
            => Query<Variety>($"SELECT * FROM {TABLE}");

        public IEnumerable<Variety> GetBySpeciesId(int speciesId)
            => Query<Variety>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });
    }
}
