using PKzen.DataAccess;

namespace PKzen.Models
{
    public class SpeciesEggGroup
    {
        public int SpeciesId { get; }
        public int EggGroupId { get; }

        private EggGroup? _eggGroup;
        private readonly EggGroupDal _eggGroupDal = new();

        public SpeciesEggGroup() { }

        public SpeciesEggGroup(int speciesId, int eggGroupId)
        {
            SpeciesId = speciesId;
            EggGroupId = eggGroupId;
        }

        public EggGroup EggGroup => _eggGroup ??= _eggGroupDal.GetById(EggGroupId);
    }
}
