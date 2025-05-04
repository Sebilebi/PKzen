using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Pokemon
    {
        private readonly SpeciesDal _speciesDal = new();
        private readonly PokemonAbilityDal _pokemonAbilityDal = new();
        private readonly PokemonStatDal _pokemonStatDal = new();
        private readonly MoveDal _moveDal = new();

        private IEnumerable<PokemonAbility>? _pokemonAbilities;
        private IEnumerable<PokemonStat>? _stats;
        private IEnumerable<Move>? _moves;
        private Species? _species;

        public int Id { get; }
        public string Name { get; }
        public int BaseExperience { get; }
        public int Weight { get; }
        public int Height { get; }
        public bool IsShiny { get; }
        public string? Gender { get; }
        public int SpeciesId { get; }

        public Pokemon() { }

        public Pokemon(int id, string name, int baseExp, int weight, int height, bool shiny, string? gender, int speciesId)
        {
            Id = id;
            Name = name;
            BaseExperience = baseExp;
            Weight = weight;
            Height = height;
            IsShiny = shiny;
            Gender = gender;
            SpeciesId = speciesId;
        }

        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
        public IEnumerable<PokemonAbility> PokemonAbilities => _pokemonAbilities ??= _pokemonAbilityDal.GetByPokemonId(Id);
        public IEnumerable<Ability> Abilities => PokemonAbilities.Select(pa => pa.Ability);
        public IEnumerable<PokemonStat> Stats => _stats ??= _pokemonStatDal.GetByPokemonId(Id);
        public IEnumerable<Move> Moves => _moves ??= _moveDal.GetByPokemonId(Id);
    }
}
