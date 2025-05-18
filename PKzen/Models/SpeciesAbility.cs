using PKzen.DataAccess;

namespace PKzen.Models
{
    public class SpeciesAbility
    {
        public int SpeciesId { get; }
        public int AbilityId { get; }

        private Ability? _ability;
        private Species? _species;

        private readonly AbilityDal _abilityDal = new();
        private readonly SpeciesDal _speciesDal = new();

        public SpeciesAbility() { }

        public SpeciesAbility(int speciesId, int abilityId)
        {
            SpeciesId = speciesId;
            AbilityId = abilityId;
        }

        public Ability Ability => _ability ??= _abilityDal.GetById(AbilityId);
        public Species Species => _species ??= _speciesDal.GetById(SpeciesId);
    }
}
