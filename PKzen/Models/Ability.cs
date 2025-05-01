namespace PKzen.Models
{
    public class Ability
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Effect { get; set; }

        private Lazy<List<Pokemon>> _pokemons;
        public List<Pokemon> Pokemons => _pokemons?.Value;
        public void SetPokemonsLoader(Func<List<Pokemon>> loader) => _pokemons = new Lazy<List<Pokemon>>(loader);
    }
}
