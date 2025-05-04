using PKzen.Models;

namespace PKzen.DataAccess
{
    public class SpeciesDal : RepositoryBase<Species>
    {
        private const string TABLE = "Species";

        public override Species GetById(int id)
            => QuerySingle<Species>(
                $"SELECT Id, BaseHappiness, CaptureRate, Color, FlavorText, FormsSwitchable, GenderRate, Genera, Generation, Habitat, HasGenderDifferences, HatchCounter, IsBaby, IsLegendary, IsMythical FROM {TABLE} WHERE Id = @Id",
                new { Id = id })!;

        public override IEnumerable<Species> GetAll()
            => Query<Species>($"SELECT * FROM {TABLE}");
    }
}
