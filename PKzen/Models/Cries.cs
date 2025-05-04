using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Cries
    {
        public int Id { get; }
        public string? Latest { get; }
        public string? Legacy { get; }
        public int SpeciesId { get; }

        private Species? _species;
        private readonly SpeciesDal _speciesDal = new();

        public Cries() { }

        public Cries(int id, string? latest, string? legacy, int speciesId)
        {
            Id = id;
            Latest = latest;
            Legacy = legacy;
            SpeciesId = speciesId;
        }

        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
    }
}
