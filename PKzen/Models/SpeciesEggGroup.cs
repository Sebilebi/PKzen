namespace PKzen.Models
{
    public class SpeciesEggGroup
    {
        public int Id { get; set; }
        public int SpeciesId { get; set; }
        public int EggGroupId { get; set; }

        private Lazy<Species> _species;
        public Species Species => _species?.Value;
        public void SetSpeciesLoader(Func<Species> loader) => _species = new Lazy<Species>(loader);

        private Lazy<EggGroup> _eggGroup;
        public EggGroup EggGroup => _eggGroup?.Value;
        public void SetEggGroupLoader(Func<EggGroup> loader) => _eggGroup = new Lazy<EggGroup>(loader);
    }
}
