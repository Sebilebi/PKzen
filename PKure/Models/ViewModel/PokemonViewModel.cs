namespace PKure.Models.ViewModel
{
    public class PokemonViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; } // Cadena que une los tipos, por ejemplo "Grass / Poison"
        public string ImageUrl { get; set; }
    }
}