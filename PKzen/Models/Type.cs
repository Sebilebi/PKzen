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

        public static string GetTypeColor(int typeId)
        {
            return typeId switch
            {
                1 => "#A8A77A", // Normal
                2 => "#C22E28", // Fighting
                3 => "#A98FF3", // Flying
                4 => "#A33EA1", // Poison
                5 => "#E2BF65", // Ground
                6 => "#B6A136", // Rock
                7 => "#A6B91A", // Bug
                8 => "#735797", // Ghost
                9 => "#B7B7CE", // Steel
                10 => "#EE8130", // Fire
                11 => "#6390F0", // Water
                12 => "#7AC74C", // Grass
                13 => "#F7D02C", // Electric
                14 => "#F95587", // Psychic
                15 => "#96D9D6", // Ice
                16 => "#6F35FC", // Dragon
                17 => "#705746", // Dark
                18 => "#D685AD", // Fairy
                _ => "#CCCCCC"  // Default (Unknown type)
            };
        }
    }
}
