namespace PKzen.Models
{
    public class EggGroup
    {
        public int Id { get; }
        public string Name { get; }

        public EggGroup(int id, string name)
        {
            Id = id;
            Name = name;
        }
    }
}
