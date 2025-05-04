using PKzen.DataAccess;

namespace PKzen.Models
{
    public class StatChange
    {
        public int Id { get; }
        public int Change { get; }
        public int StatId { get; }
        public int MoveId { get; }

        private Stat? _stat;
        private IEnumerable<StatChange>? _null;
        private readonly StatDal _statDal = new();
        private readonly MoveDal _moveDal = new();

        public StatChange() { }

        public StatChange(int id, int change, int statId, int moveId)
        {
            Id = id;
            Change = change;
            StatId = statId;
            MoveId = moveId;
        }

        public Stat Stat => _stat ??= _statDal.GetById(StatId);
        public Move Move => _moveDal.GetById(MoveId);
    }
}
