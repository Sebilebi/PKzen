namespace PKzen.Models
{
    public class Move
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool IsHidden { get; set; }

        private Lazy<List<StatChange>> _statChanges;
        public List<StatChange> StatChanges => _statChanges?.Value;
        public void SetStatChangesLoader(Func<List<StatChange>> loader) => _statChanges = new Lazy<List<StatChange>>(loader);
    }
}
