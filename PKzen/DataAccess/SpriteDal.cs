using PKzen.Models;

namespace PKzen.DataAccess
{
    public class SpriteDal : RepositoryBase<Sprite>
    {
        private const string TABLE = "Sprite";

        public override Sprite GetById(int id)
            => QuerySingle<Sprite>($"SELECT * FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<Sprite> GetAll()
            => Query<Sprite>($"SELECT * FROM {TABLE}");

        public IEnumerable<Sprite> GetBySpeciesId(int speciesId)
            => Query<Sprite>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });
    }
}
