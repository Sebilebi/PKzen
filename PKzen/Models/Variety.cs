using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Variety
    {
        public int Id { get; }
        public bool IsDefault { get; }
        public int SpeciesId { get; }

        private Species? _species;

        private readonly SpeciesDal _speciesDal = new();

        public Variety() { }

        public Variety(int id, bool isDefault, int speciesId)
        {
            Id = id;
            IsDefault = isDefault;
            SpeciesId = speciesId;
        }

        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
    }
}
