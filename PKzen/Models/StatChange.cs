namespace PKzen.Models
{
    public class StatChange
    {
        public int Id { get; set; }
        public int Change { get; set; }
        public int StatId { get; set; }
        public int MoveId { get; set; }

        private Lazy<Stat> _stat;
        public Stat Stat => _stat?.Value;
        public void SetStatLoader(Func<Stat> loader) => _stat = new Lazy<Stat>(loader);

        private Lazy<Move> _move;
        public Move Move => _move?.Value;
        public void SetMoveLoader(Func<Move> loader) => _move = new Lazy<Move>(loader);
    }
}
