namespace PKure.Models
{
    public class PokemonViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        // Cadena que une los tipos, por ejemplo "Grass / Poison"
        public string Type { get; set; }
        public string ImageUrl { get; set; }
    }
}