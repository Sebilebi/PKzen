namespace PKzen.Models
{
    public class Pokemon
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int BaseExperience { get; set; }
        public int Weight { get; set; }
        public int Height { get; set; }
        public bool IsShiny { get; set; }
        public string Gender { get; set; }
        public int SpeciesId { get; set; }
        public int AbilityId { get; set; }

        private Lazy<Species> _species;
        public Species Species => _species?.Value;
        public void SetSpeciesLoader(Func<Species> loader) => _species = new Lazy<Species>(loader);

        private Lazy<Ability> _ability;
        public Ability Ability => _ability?.Value;
        public void SetAbilityLoader(Func<Ability> loader) => _ability = new Lazy<Ability>(loader);
    }
}
