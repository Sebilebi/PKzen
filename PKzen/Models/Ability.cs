namespace PKzen.Models
{
    public class Ability
    {
        public int Id { get; }
        public string Name { get; }
        public string? Description { get; }
        public bool IsHidden { get; }

        public Ability(int id, string name, string? description, bool isHidden)
        {
            Id = id;
            Name = name;
            Description = description;
            IsHidden = isHidden;
        }
    }
}
