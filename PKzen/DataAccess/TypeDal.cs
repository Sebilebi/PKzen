using Type = PKzen.Models.Type;

namespace PKzen.DataAccess
{
    public class TypeDal : RepositoryBase<Type>
    {
        private const string TABLE = "Type";

        public override Type GetById(int id)
            => QuerySingle<Models.Type>($"SELECT Id, Name FROM {TABLE} WHERE Id = @Id", new { Id = id })!;

        public override IEnumerable<Type> GetAll()
            => Query<Type>($"SELECT Id, Name FROM {TABLE}");
    }
}
