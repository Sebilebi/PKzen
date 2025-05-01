namespace PKzen.Models
{
    public class Species
    {
        public int Id { get; set; }
        public int BaseHappiness { get; set; }
        public int CaptureRate { get; set; }
        public string Color { get; set; }
        public string FlavorText { get; set; }
        public bool FormsSwitchable { get; set; }
        public int GenderRate { get; set; }
        public string Genera { get; set; }
        public string Generation { get; set; }
        public string Habitat { get; set; }
        public bool HasGenderDifferences { get; set; }
        public int HatchCounter { get; set; }
        public bool IsBaby { get; set; }
        public string EvolutionTrigger { get; set; }
        public bool TurnUpsideDown { get; set; }
        public int EvolutionChainId { get; set; }

        // Lazy-loaded navigation properties
        private Lazy<List<Pokemon>> _pokemons;
        public List<Pokemon> Pokemons => _pokemons?.Value;
        public void SetPokemonsLoader(Func<List<Pokemon>> loader) => _pokemons = new Lazy<List<Pokemon>>(loader);

        private Lazy<EvolutionChain> _evolutionChain;
        public EvolutionChain EvolutionChain => _evolutionChain?.Value;
        public void SetEvolutionChainLoader(Func<EvolutionChain> loader) => _evolutionChain = new Lazy<EvolutionChain>(loader);
    }
}
