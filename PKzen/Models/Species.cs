using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Species
    {
        public int Id { get; }
        public int BaseHappiness { get; }
        public int CaptureRate { get; }
        public string Color { get; }
        public string? FlavorText { get; }
        public bool FormsSwitchable { get; }
        public int GenderRate { get; }
        public string? Genera { get; }
        public string? Generation { get; }
        public string? Habitat { get; }
        public bool HasGenderDifferences { get; }
        public int HatchCounter { get; }
        public bool IsBaby { get; }
        public bool IsLegendary { get; }
        public bool IsMythical { get; }

        private IEnumerable<EvolutionChain>? _evolutionChains;
        private IEnumerable<SpeciesEggGroup>? _eggGroups;
        private IEnumerable<SpeciesType>? _types;
        private IEnumerable<DamageRelation>? _relations;
        private IEnumerable<Cries>? _cries;
        private IEnumerable<Sprite>? _sprites;
        private IEnumerable<Variety>? _varieties;
        private IEnumerable<SpeciesAbility>? _abilities;

        private readonly SpeciesEggGroupDal _eggGroupDal = new();
        private readonly SpeciesTypeDal _typeDal = new();
        private readonly DamageRelationDal _damageDal = new();
        private readonly CriesDal _criesDal = new();
        private readonly SpriteDal _spriteDal = new();
        private readonly VarietyDal _varietyDal = new();
        private readonly EvolutionChainDal _evolutionChainDal = new();
        private readonly SpeciesAbilityDal _speciesAbilityDal = new();

        public Species() { }

        public Species(int id, int baseHappiness, int captureRate, string color, string? flavorText,
                       bool formsSwitchable, int genderRate, string? genera, string? generation,
                       string? habitat, bool hasGenderDifferences, int hatchCounter,
                       bool isBaby, bool isLegendary, bool isMythical)
        {
            Id = id;
            BaseHappiness = baseHappiness;
            CaptureRate = captureRate;
            Color = color;
            FlavorText = flavorText;
            FormsSwitchable = formsSwitchable;
            GenderRate = genderRate;
            Genera = genera;
            Generation = generation;
            Habitat = habitat;
            HasGenderDifferences = hasGenderDifferences;
            HatchCounter = hatchCounter;
            IsBaby = isBaby;
            IsLegendary = isLegendary;
            IsMythical = isMythical;
        }

        public IEnumerable<EvolutionChain> EvolutionChains => _evolutionChains ??= _evolutionChainDal.GetBySpeciesId(Id);
        public IEnumerable<SpeciesEggGroup> EggGroups => _eggGroups ??= _eggGroupDal.GetBySpeciesId(Id);
        public IEnumerable<SpeciesType> Types => _types ??= _typeDal.GetBySpeciesId(Id);
        public IEnumerable<DamageRelation> DamageRelations => _relations ??= _damageDal.GetBySpeciesId(Id);
        public IEnumerable<Cries> Cries => _cries ??= _criesDal.GetBySpeciesId(Id);
        public IEnumerable<Sprite> Sprites => _sprites ??= _spriteDal.GetBySpeciesId(Id);
        public IEnumerable<Variety> Varieties => _varieties ??= _varietyDal.GetBySpeciesId(Id);
        public IEnumerable<SpeciesAbility> Abilities => _abilities ??= _speciesAbilityDal.GetBySpeciesId(Id);
    }
}
