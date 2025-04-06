using System.Text.Json.Serialization;

namespace PKure.Models
{
    public class Pokemon
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("types")]
        public List<PokemonType> Types { get; set; }

        [JsonPropertyName("sprites")]
        public Sprites Sprites { get; set; }

        [JsonPropertyName("abilities")]
        public List<Ability> Abilities { get; set; }

        [JsonPropertyName("stats")]
        public List<Stat> Stats { get; set; }

        [JsonPropertyName("evolution_chain")]
        public EvolutionChain EvolutionChain { get; set; }

        // Propiedad de conveniencia para obtener la imagen principal.
        public string ImageUrl => Sprites?.FrontDefault;
    }

    public class PokemonType
    {
        [JsonPropertyName("slot")]
        public int Slot { get; set; }

        [JsonPropertyName("type")]
        public TypeInfo Type { get; set; }
    }

    public class TypeInfo
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("url")]
        public string Url { get; set; }
    }

    public class Sprites
    {
        [JsonPropertyName("front_default")]
        public string FrontDefault { get; set; }
    }

    public class Ability
    {
        [JsonPropertyName("ability")]
        public AbilityInfo AbilityInfo { get; set; }
    }

    public class AbilityInfo
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }
    }

    public class Stat
    {
        [JsonPropertyName("base_stat")]
        public int BaseStat { get; set; }

        [JsonPropertyName("stat")]
        public StatInfo StatInfo { get; set; }
    }

    public class StatInfo
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }
    }

    public class EvolutionChain
    {
        [JsonPropertyName("chain")]
        public EvolutionChainLink Chain { get; set; }
    }

    public class EvolutionChainLink
    {
        [JsonPropertyName("species")]
        public Species Species { get; set; }

        [JsonPropertyName("evolves_to")]
        public List<EvolutionChainLink> EvolvesTo { get; set; }
    }

    public class Species
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("url")]
        public string Url { get; set; }
    }
}
