using PKzen.Models;

namespace PKzen.DataAccess
{
    public class PokemonDal : RepositoryBase<Pokemon>
    {
        private const string TABLE = "Pokemon";

        public override Pokemon GetById(int id)
            => QuerySingle<Pokemon>(
                $"SELECT Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId, AbilityId FROM {TABLE} WHERE Id = @Id",
                new { Id = id })!;

        public override IEnumerable<Pokemon> GetAll()
            => Query<Pokemon>($"SELECT * FROM {TABLE}");

        public IEnumerable<Pokemon> GetBySpeciesId(int speciesId)
            => Query<Pokemon>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });
    }
}
