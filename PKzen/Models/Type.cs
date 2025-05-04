namespace PKzen.Models
{
    public class Type
    {
        public int Id { get; }
        public string Name { get; }

        public Type() { }

        public Type(int id, string name)
        {
            Id = id;
            Name = name;
        }
    }
}
