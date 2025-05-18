using PKzen.Models;

namespace PKzen.DataAccess
{
    public class SpeciesAbilityDal : RepositoryBase<SpeciesAbility>
    {
        private const string TABLE = "SpeciesAbility";

        public override SpeciesAbility GetById(int id) => throw new System.NotImplementedException();

        public override IEnumerable<SpeciesAbility> GetAll()
            => Query<SpeciesAbility>($"SELECT * FROM {TABLE}");

        public IEnumerable<SpeciesAbility> GetBySpeciesId(int speciesId)
            => Query<SpeciesAbility>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId",
                new { SpeciesId = speciesId });

        public IEnumerable<SpeciesAbility> GetByAbilityId(int abilityId)
            => Query<SpeciesAbility>($"SELECT * FROM {TABLE} WHERE AbilityId = @AbilityId",
                new { AbilityId = abilityId });
    }
}
