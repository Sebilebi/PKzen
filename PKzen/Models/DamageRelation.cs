using PKzen.DataAccess;

namespace PKzen.Models
{
    public class DamageRelation
    {
        public int SpeciesId { get; }
        public int TypeId { get; }
        public double RelationType { get; }

        private Type? _type;
        private readonly TypeDal _typeDal = new();

        public DamageRelation(int speciesId, int typeId, double relationType)
        {
            SpeciesId = speciesId;
            TypeId = typeId;
            RelationType = relationType;
        }

        public Type Type => _type ??= _typeDal.GetById(TypeId);
    }
}
