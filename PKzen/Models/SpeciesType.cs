namespace PKzen.Models
{
    public class SpeciesType
    {
        public int Id { get; set; }
        public int Slot { get; set; }
        public int SpeciesId { get; set; }
        public int TypeId { get; set; }

        private Lazy<Species> _species;
        public Species Species => _species?.Value;
        public void SetSpeciesLoader(Func<Species> loader) => _species = new Lazy<Species>(loader);

        private Lazy<Type> _type;
        public Type Type => _type?.Value;
        public void SetTypeLoader(Func<Type> loader) => _type = new Lazy<Type>(loader);
    }
}
