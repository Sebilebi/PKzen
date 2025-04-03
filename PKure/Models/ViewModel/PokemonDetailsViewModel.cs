namespace PKure.Models.ViewModel
{
    public class PokemonDetailViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public List<string> Types { get; set; }
        public List<StatViewModel> Stats { get; set; }
        public string ImageUrl { get; set; }
    }

    public class StatViewModel
    {
        public string Name { get; set; }
        public int Value { get; set; }
    }
}
