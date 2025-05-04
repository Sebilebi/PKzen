using PKzen.DataAccess;

namespace PKzen.Models
{
    public class PokemonStat
    {
        public int Id { get; }
        public int BaseStat { get; }
        public int Effort { get; }
        public int PokemonId { get; }
        public int StatId { get; }

        private Pokemon? _pokemon;
        private Stat? _stat;
        private readonly PokemonDal _pokemonDal = new();
        private readonly StatDal _statDal = new();

        public PokemonStat(int id, int baseStat, int effort, int pokemonId, int statId)
        {
            Id = id;
            BaseStat = baseStat;
            Effort = effort;
            PokemonId = pokemonId;
            StatId = statId;
        }

        public Pokemon Pokemon => _pokemon ??= _pokemonDal.GetById(PokemonId);
        public Stat Stat => _stat ??= _statDal.GetById(StatId);
    }
}
