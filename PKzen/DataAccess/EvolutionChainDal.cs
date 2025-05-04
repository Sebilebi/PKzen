using PKzen.Models;

namespace PKzen.DataAccess
{
    public class EvolutionChainDal : RepositoryBase<EvolutionChain>
    {
        private const string TABLE = "EvolutionChain";

        public override EvolutionChain GetById(int id)
            => QuerySingle<EvolutionChain>($"SELECT * FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<EvolutionChain> GetAll()
            => Query<EvolutionChain>($"SELECT * FROM {TABLE}");

        public IEnumerable<EvolutionChain> GetBySpeciesId(int speciesId)
            => Query<EvolutionChain>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });
    }
}
