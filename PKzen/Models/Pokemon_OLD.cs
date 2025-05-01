using System.Text.Json.Serialization;

namespace PKzen.Models
{
    public class Pokemon_OLD
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
        public List<Ability_OLD> Abilities { get; set; }

        [JsonPropertyName("forms")]
        public List<NamedApiResource_OLD> Forms { get; set; }

        [JsonPropertyName("game_indices")]
        public List<VersionGameIndex_OLD> GameIndices { get; set; }

        [JsonPropertyName("held_items")]
        public List<HeldItem_OLD> HeldItems { get; set; }

        [JsonPropertyName("location_area_encounters")]
        public string LocationAreaEncounters { get; set; }

        [JsonPropertyName("moves")]
        public List<PokemonMove_OLD> Moves { get; set; }

        [JsonPropertyName("sprites")]
        public Sprites_OLD Sprites { get; set; }

        [JsonPropertyName("species")]
        public NamedApiResource_OLD Species { get; set; }

        [JsonPropertyName("stats")]
        public List<Stat_OLD> Stats { get; set; }

        [JsonPropertyName("types")]
        public List<PokemonType_OLD> Types { get; set; }

        [JsonPropertyName("past_types")]
        public List<PokemonTypePast_OLD> PastTypes { get; set; }

        [JsonPropertyName("evolution_chain")]
        public EvolutionChain_OLD EvolutionChain { get; set; }

        // Propiedad de conveniencia para obtener la imagen principal.
        public string ImageUrl => Sprites?.FrontDefault;
        // Propiedad de conveniencia para obtener la imagen principal (ahora usa official-artwork)
        public string ImageUrlOfficial => Sprites?.Other?.OfficialArtwork?.FrontDefault ?? Sprites?.FrontDefault;

        // Propiedades localizadas
        public PokemonSpecies_OLD SpeciesDetails { get; set; }
    }

    public class Ability_OLD
    {
        [JsonPropertyName("is_hidden")]
        public bool IsHidden { get; set; }

        [JsonPropertyName("slot")]
        public int Slot { get; set; }

        [JsonPropertyName("ability")]
        public NamedApiResource_OLD AbilityInfo { get; set; }

        // Detalles localizados de la habilidad
        public AbilityDetails_OLD Details { get; set; }
    }

    public class AbilityDetails_OLD
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name_OLD> Names { get; set; }

        [JsonPropertyName("effect_entries")]
        public List<EffectEntry_OLD> EffectEntries { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language)
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }

        // Método para obtener el efecto localizado
        public string GetLocalizedEffect(string language)
        {
            return EffectEntries?.FirstOrDefault(e => e.Language.Name == language)?.Effect ?? "";
        }
    }

    public class EffectEntry_OLD
    {
        [JsonPropertyName("effect")]
        public string Effect { get; set; }

        [JsonPropertyName("short_effect")]
        public string ShortEffect { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource_OLD Language { get; set; }
    }

    public class Name_OLD
    {
        [JsonPropertyName("name")]
        public string Value { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource_OLD Language { get; set; }
    }

    public class NamedApiResource_OLD
    {
        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("url")]
        public string Url { get; set; }
    }

    public class VersionGameIndex_OLD
    {
        [JsonPropertyName("game_index")]
        public int GameIndex { get; set; }

        [JsonPropertyName("version")]
        public NamedApiResource_OLD Version { get; set; }
    }

    public class HeldItem_OLD
    {
        [JsonPropertyName("item")]
        public NamedApiResource_OLD Item { get; set; }

        [JsonPropertyName("version_details")]
        public List<HeldItemVersion_OLD> VersionDetails { get; set; }
    }

    public class HeldItemVersion_OLD
    {
        [JsonPropertyName("version")]
        public NamedApiResource_OLD Version { get; set; }

        [JsonPropertyName("rarity")]
        public int Rarity { get; set; }
    }

    public class PokemonMove_OLD
    {
        [JsonPropertyName("move")]
        public NamedApiResource_OLD Move { get; set; }

        [JsonPropertyName("version_group_details")]
        public List<MoveVersion_OLD> VersionGroupDetails { get; set; }

        // Detalles localizados del movimiento
        public MoveDetails_OLD Details { get; set; }
    }

    public class MoveDetails_OLD
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name_OLD> Names { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language)
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }
    }

    public class MoveVersion_OLD
    {
        [JsonPropertyName("move_learn_method")]
        public NamedApiResource_OLD MoveLearnMethod { get; set; }

        [JsonPropertyName("version_group")]
        public NamedApiResource_OLD VersionGroup { get; set; }

        [JsonPropertyName("level_learned_at")]
        public int LevelLearnedAt { get; set; }
    }

    public class Sprites_OLD
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
        public OtherSprites_OLD Other { get; set; }

        [JsonPropertyName("versions")]
        public Dictionary<string, Dictionary<string, Sprites_OLD>> Versions { get; set; }
    }

    public class OtherSprites_OLD
    {
        [JsonPropertyName("dream_world")]
        public DreamWorld_OLD DreamWorld { get; set; }

        [JsonPropertyName("official-artwork")]
        public OfficialArtwork_OLD OfficialArtwork { get; set; }
    }

    public class DreamWorld_OLD
    {
        [JsonPropertyName("front_default")]
        public string FrontDefault { get; set; }

        [JsonPropertyName("front_female")]
        public string FrontFemale { get; set; }
    }

    public class OfficialArtwork_OLD
    {
        [JsonPropertyName("front_default")]
        public string FrontDefault { get; set; }
    }

    public class Stat_OLD
    {
        [JsonPropertyName("base_stat")]
        public int BaseStat { get; set; }

        [JsonPropertyName("effort")]
        public int Effort { get; set; }

        [JsonPropertyName("stat")]
        public NamedApiResource_OLD StatInfo { get; set; }

        // Detalles localizados de la estadística
        public StatDetails_OLD Details { get; set; }
    }

    public class StatDetails_OLD
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name_OLD> Names { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language)
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }
    }

    public class PokemonType_OLD
    {
        [JsonPropertyName("slot")]
        public int Slot { get; set; }

        [JsonPropertyName("type")]
        public NamedApiResource_OLD Type { get; set; }

        // Detalles localizados del tipo
        public TypeDetails_OLD Details { get; set; }
    }

    public class TypeDetails_OLD
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name_OLD> Names { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language)
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }

        public string TypeSprite => $"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-ix/scarlet-violet/{Id}.png";
    }

    public class PokemonTypePast_OLD
    {
        [JsonPropertyName("generation")]
        public NamedApiResource_OLD Generation { get; set; }

        [JsonPropertyName("types")]
        public List<PokemonType_OLD> Types { get; set; }
    }

    public class EvolutionChain_OLD
    {
        [JsonPropertyName("chain")]
        public EvolutionChainLink_OLD Chain { get; set; }
    }

    public class EvolutionChainLink_OLD
    {
        [JsonPropertyName("species")]
        public NamedApiResource_OLD Species { get; set; }

        [JsonPropertyName("evolves_to")]
        public List<EvolutionChainLink_OLD> EvolvesTo { get; set; }

        [JsonPropertyName("evolution_details")]
        public List<EvolutionDetail_OLD> EvolutionDetails { get; set; }

        // Detalles localizados de la especie
        public PokemonSpecies_OLD SpeciesDetails { get; set; }
    }

    public class PokemonSpecies_OLD
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("name")]
        public string Name { get; set; }

        [JsonPropertyName("names")]
        public List<Name_OLD> Names { get; set; }

        [JsonPropertyName("genera")]
        public List<Genus_OLD> Genera { get; set; }

        [JsonPropertyName("flavor_text_entries")]
        public List<FlavorTextEntry_OLD> FlavorTextEntries { get; set; }

        [JsonPropertyName("evolution_chain")]
        public EvolutionChainReference_OLD EvolutionChainReference { get; set; }

        // Método para obtener el nombre localizado
        public string GetLocalizedName(string language)
        {
            return Names?.FirstOrDefault(n => n.Language.Name == language)?.Value ?? Name;
        }

        // Método para obtener el género localizado (como "Pokémon Ratón" o "Pokémon Emperador")
        public string GetLocalizedGenus(string language)
        {
            return Genera?.FirstOrDefault(g => g.Language.Name == language)?.Genuss ?? "";
        }

        // Método para obtener la descripción localizada
        public string GetLocalizedFlavorText(string language)
        {
            return FlavorTextEntries?.FirstOrDefault(f => f.Language.Name == language)?.FlavorText ?? "";
        }
    }

    public class Genus_OLD
    {
        [JsonPropertyName("genus")]
        public string Genuss { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource_OLD Language { get; set; }
    }

    public class FlavorTextEntry_OLD
    {
        [JsonPropertyName("flavor_text")]
        public string FlavorText { get; set; }

        [JsonPropertyName("language")]
        public NamedApiResource_OLD Language { get; set; }

        [JsonPropertyName("version")]
        public NamedApiResource_OLD Version { get; set; }
    }

    public class EvolutionChainReference_OLD
    {
        [JsonPropertyName("url")]
        public string Url { get; set; }
    }

    public class EvolutionDetail_OLD
    {
        [JsonPropertyName("item")]
        public NamedApiResource_OLD Item { get; set; }

        [JsonPropertyName("trigger")]
        public NamedApiResource_OLD Trigger { get; set; }

        [JsonPropertyName("gender")]
        public int? Gender { get; set; }

        [JsonPropertyName("held_item")]
        public NamedApiResource_OLD HeldItem { get; set; }

        [JsonPropertyName("known_move")]
        public NamedApiResource_OLD KnownMove { get; set; }

        [JsonPropertyName("known_move_type")]
        public NamedApiResource_OLD KnownMoveType { get; set; }

        [JsonPropertyName("location")]
        public NamedApiResource_OLD Location { get; set; }

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
        public NamedApiResource_OLD PartySpecies { get; set; }

        [JsonPropertyName("party_type")]
        public NamedApiResource_OLD PartyType { get; set; }

        [JsonPropertyName("relative_physical_stats")]
        public int? RelativePhysicalStats { get; set; }

        [JsonPropertyName("time_of_day")]
        public string TimeOfDay { get; set; }

        [JsonPropertyName("trade_species")]
        public NamedApiResource_OLD TradeSpecies { get; set; }

        [JsonPropertyName("turn_upside_down")]
        public bool TurnUpsideDown { get; set; }
    }
}