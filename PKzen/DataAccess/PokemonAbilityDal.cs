using PKzen.Models;

namespace PKzen.DataAccess
{
    public class PokemonAbilityDal : RepositoryBase<PokemonAbility>
    {
        private const string TABLE = "PokemonAbility";

        public override PokemonAbility GetById(int id)
            => throw new NotSupportedException("La entidad PokemonAbility tiene clave compuesta; use métodos específicos.");

        public override IEnumerable<PokemonAbility> GetAll()
            => Query<PokemonAbility>($"SELECT PokemonId, AbilityId FROM {TABLE}");

        public IEnumerable<PokemonAbility> GetByPokemonId(int pokemonId)
            => Query<PokemonAbility>(
                $"SELECT PokemonId, AbilityId FROM {TABLE} WHERE PokemonId = @Pid",
                new { Pid = pokemonId });

        public IEnumerable<PokemonAbility> GetByAbilityId(int abilityId)
            => Query<PokemonAbility>(
                $"SELECT PokemonId, AbilityId FROM {TABLE} WHERE AbilityId = @Aid",
                new { Aid = abilityId });
    }
}
