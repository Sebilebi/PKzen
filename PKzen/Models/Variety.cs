namespace PKzen.Models
{
    public class Variety
    {
        public int Id { get; set; }
        public bool IsDefault { get; set; }
        public string Name { get; set; }
        public int SpeciesId { get; set; }

        private Lazy<Species> _species;
        public Species Species => _species?.Value;
        public void SetSpeciesLoader(Func<Species> loader) => _species = new Lazy<Species>(loader);
    }
}
