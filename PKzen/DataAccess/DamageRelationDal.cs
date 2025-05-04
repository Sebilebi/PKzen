using PKzen.Models;

namespace PKzen.DataAccess
{
    public class DamageRelationDal : RepositoryBase<DamageRelation>
    {
        private const string TABLE = "DamageRelation";

        public override DamageRelation GetById(int id) => throw new System.NotImplementedException();

        public override IEnumerable<DamageRelation> GetAll()
            => Query<DamageRelation>($"SELECT * FROM {TABLE}");

        public IEnumerable<DamageRelation> GetBySpeciesId(int speciesId)
            => Query<DamageRelation>($"SELECT * FROM {TABLE} WHERE SpeciesId = @SpeciesId", new { SpeciesId = speciesId });
    }
}
