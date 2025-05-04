using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Sprite
    {
        public int Id { get; }
        public string? Name { get; }
        public bool Icon { get; }
        public string? BackMale { get; }
        public string? BackFemale { get; }
        public string? BackShiny { get; }
        public string? BackShinyFemale { get; }
        public string? FrontMale { get; }
        public string? FrontFemale { get; }
        public string? FrontShiny { get; }
        public string? FrontShinyFemale { get; }
        public int SpeciesId { get; }

        private Species? _species;
        private readonly SpeciesDal _speciesDal = new();

        public Sprite(int id, string? name, bool icon, string? backMale, string? backFemale,
                      string? backShiny, string? backShinyFemale, string? frontMale,
                      string? frontFemale, string? frontShiny, string? frontShinyFemale, int speciesId)
        {
            Id = id;
            Name = name;
            Icon = icon;
            BackMale = backMale;
            BackFemale = backFemale;
            BackShiny = backShiny;
            BackShinyFemale = backShinyFemale;
            FrontMale = frontMale;
            FrontFemale = frontFemale;
            FrontShiny = frontShiny;
            FrontShinyFemale = frontShinyFemale;
            SpeciesId = speciesId;
        }

        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
    }
}
