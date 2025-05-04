using PKzen.DataAccess;

namespace PKzen.Models
{
    public class SpeciesType
    {
        public int Id { get; }
        public int Slot { get; }
        public int SpeciesId { get; }
        public int TypeId { get; }

        private Type? _type;
        private readonly TypeDal _typeDal = new();

        public SpeciesType() { }

        public SpeciesType(int id, int slot, int speciesId, int typeId)
        {
            Id = id;
            Slot = slot;
            SpeciesId = speciesId;
            TypeId = typeId;
        }

        public Type Type => _type ??= _typeDal.GetById(TypeId);
    }
}
