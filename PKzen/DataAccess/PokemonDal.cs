using PKzen.Models;

namespace PKzen.DataAccess
{
    public class PokemonDal : RepositoryBase<Pokemon>
    {
        private const string TABLE = "Pokemon";

        public override Pokemon GetById(int id)
            => QuerySingle<Pokemon>(
                $"SELECT Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId FROM {TABLE} WHERE Id = @Id",
                new { Id = id })!;

        public Pokemon GetByName(string name)
            => QuerySingle<Pokemon>(
                $"SELECT Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId FROM {TABLE} WHERE Name = @Name",
                new { Name = name })!;

        public override IEnumerable<Pokemon> GetAll()
            => Query<Pokemon>(
                $"SELECT Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId FROM {TABLE}");

        public IEnumerable<Pokemon> GetBySpeciesId(int speciesId)
            => Query<Pokemon>(
                $"SELECT * FROM {TABLE} WHERE SpeciesId = @Sid",
                new { Sid = speciesId });
    }
}
