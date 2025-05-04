namespace PKzen.Models
{
    public class Stat
    {
        public int Id { get; }
        public string Name { get; }

        public Stat() { }

        public Stat(int id, string name)
        {
            Id = id;
            Name = name;
        }
    }
}
