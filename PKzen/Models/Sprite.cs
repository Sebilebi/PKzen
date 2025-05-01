namespace PKzen.Models
{
    public class Sprite
    {
        public int Id { get; set; }
        public string Filename { get; set; }
        public int PokemonId { get; set; }

        private Lazy<Pokemon> _pokemon;
        public Pokemon Pokemon => _pokemon?.Value;
        public void SetPokemonLoader(Func<Pokemon> loader) => _pokemon = new Lazy<Pokemon>(loader);
    }
}
