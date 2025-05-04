using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Variety
    {
        public int Id { get; }
        public bool IsDefault { get; }
        public string Name { get; }
        public int SpeciesId { get; }

        private Species? _species;
        private readonly SpeciesDal _speciesDal = new();

        public Variety(int id, bool isDefault, string name, int speciesId)
        {
            Id = id;
            IsDefault = isDefault;
            Name = name;
            SpeciesId = speciesId;
        }

        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
    }
}
