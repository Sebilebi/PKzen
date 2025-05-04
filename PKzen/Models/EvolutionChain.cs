using PKzen.DataAccess;

namespace PKzen.Models
{
    public class EvolutionChain
    {
        public int Id { get; }
        public string? BabyTriggerItem { get; }
        public int SpeciesId { get; }

        private Species? _species;
        private IEnumerable<EvolutionFamilyMember>? _members;
        private readonly SpeciesDal _speciesDal = new();
        private readonly EvolutionFamilyMemberDal _memberDal = new();

        public EvolutionChain() { }

        public EvolutionChain(int id, string? babyTriggerItem, int speciesId)
        {
            Id = id;
            BabyTriggerItem = babyTriggerItem;
            SpeciesId = speciesId;
        }

        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
        public IEnumerable<EvolutionFamilyMember> Members => _members ??= _memberDal.GetByChainId(Id);
    }
}
