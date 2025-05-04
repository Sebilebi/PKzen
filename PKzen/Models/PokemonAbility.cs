using PKzen.DataAccess;

namespace PKzen.Models
{
    public class PokemonAbility
    {
        private readonly PokemonDal _pokemonDal = new();
        private readonly AbilityDal _abilityDal = new();

        public int PokemonId { get; }
        public int AbilityId { get; }

        private Pokemon? _pokemon;
        private Ability? _ability;

        public PokemonAbility() { }

        public PokemonAbility(int pokemonId, int abilityId)
        {
            PokemonId = pokemonId;
            AbilityId = abilityId;
        }

        public Pokemon Pokemon => _pokemon ??= _pokemonDal.GetById(PokemonId);
        public Ability Ability => _ability ??= _abilityDal.GetById(AbilityId);
    }
}
