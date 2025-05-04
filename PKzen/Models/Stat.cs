namespace PKzen.Models
{
    public class Stat
    {
        public int Id { get; }
        public string Name { get; }

        public Stat(int id, string name)
        {
            Id = id;
            Name = name;
        }
    }
}
