using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Pokemon
    {
        private readonly PokemonDal _dal = new();
        private Species? _species;
        private Ability? _ability;
        private IEnumerable<PokemonStat>? _stats;
        private IEnumerable<Move>? _moves;

        public int Id { get; }
        public string Name { get; }
        public int BaseExperience { get; }
        public int Weight { get; }
        public int Height { get; }
        public bool IsShiny { get; }
        public string? Gender { get; }
        public int SpeciesId { get; }
        public int AbilityId { get; }

        public Pokemon(int id, string name, int baseExperience, int weight, int height,
                       bool isShiny, string? gender, int speciesId, int abilityId)
        {
            Id = id;
            Name = name;
            BaseExperience = baseExperience;
            Weight = weight;
            Height = height;
            IsShiny = isShiny;
            Gender = gender;
            SpeciesId = speciesId;
            AbilityId = abilityId;
        }

        public Species Species => _species ??= new SpeciesDal().GetById(SpeciesId);
        public Ability Ability => _ability ??= new AbilityDal().GetById(AbilityId);
        public IEnumerable<PokemonStat> Stats => _stats ??= new PokemonStatDal().GetByPokemonId(Id);
        public IEnumerable<Move> Moves => _moves ??= new MoveDal().GetByPokemonId(Id);
    }
}
