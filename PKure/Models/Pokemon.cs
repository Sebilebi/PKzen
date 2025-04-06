using System.Text.Json.Serialization;

namespace PKure.Models
{
    public class Pokemon
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("base_experience")]
        public int BaseExperience { get; set; }

        [JsonPropertyName("height")]
        public int Height { get; set; }

        [JsonPropertyName("is_default")]
        public bool IsDefault { get; set; }

        [JsonPropertyName("order")]
        public int Order { get; set; }

        [JsonPropertyName("weight")]
        public int Weight { get; set; }

        [JsonPropertyName("abilities")]
        public List<Ability> Abilities { get; set; }

        [JsonPropertyName("forms")]
        public List<NamedApiResource> Forms { get; set; }

        [JsonPropertyName("game_indices")]
        public List<VersionGameIndex> GameIndices { get; set; }

        [JsonPropertyName("held_items")]
        public List<HeldItem> HeldItems { get; set; }

        [JsonPropertyName("location_area_encounters")]
        public string LocationAreaEncounters { get; set; }

        [JsonPropertyName("moves")]
        public List<PokemonMove> Moves { get; set; }

        [JsonPropertyName("sprites")]
        public Sprites Sprites { get; set; }

        [JsonPropertyName("species")]
        public NamedApiResource Species { get; set; }

        [JsonPropertyName("stats")]
        public List<Stat> Stats { get; set; }

        [JsonPropertyName("types")]
        public List<PokemonType> Types { get; set; }

        [JsonPropertyName("past_types")]
        public List<PokemonTypePast> PastTypes { get; set; }

        [JsonPropertyName("evolution_chain")]
        public EvolutionChain EvolutionChain { get; set; }

        // Propiedad de conveniencia para obtener la imagen principal.
        public string ImageUrl => Sprites?.FrontDefault;

        // Propiedades localizadas
        public PokemonSpecies SpeciesDetails { get; set; }
    }

    public class Ability
    {
        [JsonPropertyName("is_hidden")]
        public bool IsHidden { get; set; }

        [JsonPropertyName("slot")]
        public int Slot { get; set; }

        [JsonPropertyName("ability")]
        public NamedApiResource AbilityInfo { get; set; }

        // Detalles localizados de la habilidad
        public AbilityDetails Details { get; set; }
    }

    public class AbilityDetails
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name> Names { get; set; }

        [JsonPropertyName("effect_entries")]
        public List<EffectEntry> EffectEntries { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language = "es")
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }

        // Método para obtener el efecto localizado
        public string GetLocalizedEffect(string language = "es")
        {
            return EffectEntries?.FirstOrDefault(e => e.Language.Name == language)?.Effect ?? "";
        }
    }

    public class EffectEntry
    {
        [JsonPropertyName("effect")]
        public string Effect { get; set; }

        [JsonPropertyName("short_effect")]
        public string ShortEffect { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource Language { get; set; }
    }

    public class Name
    {
        [JsonPropertyName("name")]
        public string Value { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource Language { get; set; }
    }

    public class NamedApiResource
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("url")]
        public string Url { get; set; }
    }

    public class VersionGameIndex
    {
        [JsonPropertyName("game_index")]
        public int GameIndex { get; set; }

        [JsonPropertyName("version")]
        public NamedApiResource Version { get; set; }
    }

    public class HeldItem
    {
        [JsonPropertyName("item")]
        public NamedApiResource Item { get; set; }

        [JsonPropertyName("version_details")]
        public List<HeldItemVersion> VersionDetails { get; set; }
    }

    public class HeldItemVersion
    {
        [JsonPropertyName("version")]
        public NamedApiResource Version { get; set; }

        [JsonPropertyName("rarity")]
        public int Rarity { get; set; }
    }

    public class PokemonMove
    {
        [JsonPropertyName("move")]
        public NamedApiResource Move { get; set; }

        [JsonPropertyName("version_group_details")]
        public List<MoveVersion> VersionGroupDetails { get; set; }

        // Detalles localizados del movimiento
        public MoveDetails Details { get; set; }
    }

    public class MoveDetails
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name> Names { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language = "es")
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }
    }

    public class MoveVersion
    {
        [JsonPropertyName("move_learn_method")]
        public NamedApiResource MoveLearnMethod { get; set; }

        [JsonPropertyName("version_group")]
        public NamedApiResource VersionGroup { get; set; }

        [JsonPropertyName("level_learned_at")]
        public int LevelLearnedAt { get; set; }
    }

    public class Sprites
    {
        [JsonPropertyName("front_default")]
        public string FrontDefault { get; set; }

        [JsonPropertyName("front_shiny")]
        public string FrontShiny { get; set; }

        [JsonPropertyName("front_female")]
        public string FrontFemale { get; set; }

        [JsonPropertyName("front_shiny_female")]
        public string FrontShinyFemale { get; set; }

        [JsonPropertyName("back_default")]
        public string BackDefault { get; set; }

        [JsonPropertyName("back_shiny")]
        public string BackShiny { get; set; }

        [JsonPropertyName("back_female")]
        public string BackFemale { get; set; }

        [JsonPropertyName("back_shiny_female")]
        public string BackShinyFemale { get; set; }

        [JsonPropertyName("other")]
        public OtherSprites Other { get; set; }

        [JsonPropertyName("versions")]
        public Dictionary<string, Dictionary<string, Sprites>> Versions { get; set; }
    }

    public class OtherSprites
    {
        [JsonPropertyName("dream_world")]
        public DreamWorld DreamWorld { get; set; }

        [JsonPropertyName("official-artwork")]
        public OfficialArtwork OfficialArtwork { get; set; }
    }

    public class DreamWorld
    {
        [JsonPropertyName("front_default")]
        public string FrontDefault { get; set; }

        [JsonPropertyName("front_female")]
        public string FrontFemale { get; set; }
    }

    public class OfficialArtwork
    {
        [JsonPropertyName("front_default")]
        public string FrontDefault { get; set; }
    }

    public class Stat
    {
        [JsonPropertyName("base_stat")]
        public int BaseStat { get; set; }

        [JsonPropertyName("effort")]
        public int Effort { get; set; }

        [JsonPropertyName("stat")]
        public NamedApiResource StatInfo { get; set; }

        // Detalles localizados de la estadística
        public StatDetails Details { get; set; }
    }

    public class StatDetails
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name> Names { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language = "es")
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }
    }

    public class PokemonType
    {
        [JsonPropertyName("slot")]
        public int Slot { get; set; }

        [JsonPropertyName("type")]
        public NamedApiResource Type { get; set; }

        // Detalles localizados del tipo
        public TypeDetails Details { get; set; }
    }

    public class TypeDetails
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name> Names { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language = "es")
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }
    }

    public class PokemonTypePast
    {
        [JsonPropertyName("generation")]
        public NamedApiResource Generation { get; set; }

        [JsonPropertyName("types")]
        public List<PokemonType> Types { get; set; }
    }

    public class EvolutionChain
    {
        [JsonPropertyName("chain")]
        public EvolutionChainLink Chain { get; set; }
    }

    public class EvolutionChainLink
    {
        [JsonPropertyName("species")]
        public NamedApiResource Species { get; set; }

        [JsonPropertyName("evolves_to")]
        public List<EvolutionChainLink> EvolvesTo { get; set; }

        [JsonPropertyName("evolution_details")]
        public List<EvolutionDetail> EvolutionDetails { get; set; }

        // Detalles localizados de la especie
        public PokemonSpecies SpeciesDetails { get; set; }
    }

    public class PokemonSpecies
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name> Names { get; set; }

        [JsonPropertyName("genera")]
        public List<Genus> Genera { get; set; }

        [JsonPropertyName("flavor_text_entries")]
        public List<FlavorTextEntry> FlavorTextEntries { get; set; }

        [JsonPropertyName("evolution_chain")]
        public EvolutionChainReference EvolutionChainReference { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language = "es")
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }

        // Método para obtener el género localizado (como "Pokémon Ratón" o "Pokémon Emperador")
        public string GetLocalizedGenus(string language = "es")
        {
            return Genera?.FirstOrDefault(g => g.Language.Name == language)?.Genuss ?? "";
        }

        // Método para obtener la descripción localizada
        public string GetLocalizedFlavorText(string language = "es")
        {
            return FlavorTextEntries?.FirstOrDefault(f => f.Language.Name == language)?.FlavorText ?? "";
        }
    }

    public class Genus
    {
        [JsonPropertyName("genus")]
        public string Genuss { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource Language { get; set; }
    }

    public class FlavorTextEntry
    {
        [JsonPropertyName("flavor_text")]
        public string FlavorText { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource Language { get; set; }

        [JsonPropertyName("version")]
        public NamedApiResource Version { get; set; }
    }

    public class EvolutionChainReference
    {
        [JsonPropertyName("url")]
        public string Url { get; set; }
    }

    public class EvolutionDetail
    {
        [JsonPropertyName("item")]
        public NamedApiResource Item { get; set; }

        [JsonPropertyName("trigger")]
        public NamedApiResource Trigger { get; set; }

        [JsonPropertyName("gender")]
        public int? Gender { get; set; }

        [JsonPropertyName("held_item")]
        public NamedApiResource HeldItem { get; set; }

        [JsonPropertyName("known_move")]
        public NamedApiResource KnownMove { get; set; }

        [JsonPropertyName("known_move_type")]
        public NamedApiResource KnownMoveType { get; set; }

        [JsonPropertyName("location")]
        public NamedApiResource Location { get; set; }

        [JsonPropertyName("min_level")]
        public int? MinLevel { get; set; }

        [JsonPropertyName("min_happiness")]
        public int? MinHappiness { get; set; }

        [JsonPropertyName("min_beauty")]
        public int? MinBeauty { get; set; }

        [JsonPropertyName("min_affection")]
        public int? MinAffection { get; set; }

        [JsonPropertyName("needs_overworld_rain")]
        public bool NeedsOverworldRain { get; set; }

        [JsonPropertyName("party_species")]
        public NamedApiResource PartySpecies { get; set; }

        [JsonPropertyName("party_type")]
        public NamedApiResource PartyType { get; set; }

        [JsonPropertyName("relative_physical_stats")]
        public int? RelativePhysicalStats { get; set; }

        [JsonPropertyName("time_of_day")]
        public string TimeOfDay { get; set; }

        [JsonPropertyName("trade_species")]
        public NamedApiResource TradeSpecies { get; set; }

        [JsonPropertyName("turn_upside_down")]
        public bool TurnUpsideDown { get; set; }
    }
}