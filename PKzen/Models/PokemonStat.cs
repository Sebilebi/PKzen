namespace PKzen.Models
{
    public class PokemonStat
    {
        public int Id { get; set; }
        public int PokemonId { get; set; }
        public int StatId { get; set; }
        public int BaseStat { get; set; }
        public int Effort { get; set; }

        private Lazy<Pokemon> _pokemon;
        public Pokemon Pokemon => _pokemon?.Value;
        public void SetPokemonLoader(Func<Pokemon> loader) => _pokemon = new Lazy<Pokemon>(loader);

        private Lazy<Stat> _stat;
        public Stat Stat => _stat?.Value;
        public void SetStatLoader(Func<Stat> loader) => _stat = new Lazy<Stat>(loader);
    }
}
