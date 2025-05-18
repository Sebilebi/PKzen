using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Ability
    {
        public int Id { get; }
        public string Name { get; }
        public string? Description { get; }
        public bool IsHidden { get; }
        public bool IsSelected { get; }

        private IEnumerable<SpeciesAbility>? _speciesAbilities;

        private readonly SpeciesAbilityDal _speciesAbilityDal = new();
        private readonly PokemonDal _pokemonDal = new();

        public Ability() { }

        public Ability(int id, string name, string? description, bool isHidden, bool isSelected)
        {
            Id = id;
            Name = name;
            Description = description;
            IsHidden = isHidden;
            IsSelected = isSelected;
        }

        public IEnumerable<SpeciesAbility> SpeciesAbilities => _speciesAbilities ??= _speciesAbilityDal.GetByAbilityId(Id);
        public IEnumerable<Species> Species => SpeciesAbilities.Select(sa => sa.Species);
        public IEnumerable<Pokemon> Pokemons => Species.SelectMany(s => _pokemonDal.GetBySpeciesId(s.Id));
    }
}
