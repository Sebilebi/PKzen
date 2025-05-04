using PKzen.Models;

namespace PKzen.DataAccess
{
    public class SpeciesEggGroupDal : RepositoryBase<SpeciesEggGroup>
    {
        private const string TABLE = "SpeciesEggGroup";

        public override SpeciesEggGroup GetById(int id) => throw new System.NotImplementedException();

        public override IEnumerable<SpeciesEggGroup> GetAll()
            => Query<SpeciesEggGroup>($"SELECT * FROM {TABLE}");

        public IEnumerable<SpeciesEggGroup> GetBySpeciesId(int speciesId)
            => Query<SpeciesEggGroup>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });

        public IEnumerable<SpeciesEggGroup> GetByEggGroupId(int eggGroupId)
            => Query<SpeciesEggGroup>($"SELECT * FROM {TABLE} WHERE EggGroupId = @EggGroupId", new { EggGroupId = eggGroupId });
    }
}
