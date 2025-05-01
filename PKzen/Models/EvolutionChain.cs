namespace PKzen.Models
{
    public class EvolutionChain
    {
        public int Id { get; set; }
        public string BabyTriggerItem { get; set; }
        public int SpeciesId { get; set; }

        private Lazy<List<EvolutionFamilyMember>> _members;
        public List<EvolutionFamilyMember> Members => _members?.Value;
        public void SetMembersLoader(Func<List<EvolutionFamilyMember>> loader) => _members = new Lazy<List<EvolutionFamilyMember>>(loader);
    }
}
