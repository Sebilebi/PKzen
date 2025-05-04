using PKzen.DataAccess;

namespace PKzen.Models
{
    public class EvolutionFamilyMember
    {
        public int Id { get; }
        public int? PokemonEvolutionId { get; }
        public string Name { get; }
        public string? Gender { get; }
        public string? HeldItem { get; }
        public string? Item { get; }
        public string? KnownMove { get; }
        public string? KnownMoveType { get; }
        public string? Location { get; }
        public int? MinAffection { get; }
        public int? MinBeauty { get; }
        public int? MinHappiness { get; }
        public int? MinLevel { get; }
        public bool NeedsOverworldRain { get; }
        public string? PartySpecies { get; }
        public string? PartyType { get; }
        public string? RelativePhysicalStats { get; }
        public string? TimeOfDay { get; }
        public string? TradeSpecies { get; }
        public string? EvolutionTrigger { get; }
        public bool TurnUpsideDown { get; }
        public int EvolutionChainId { get; }

        private EvolutionChain? _chain;
        private readonly EvolutionChainDal _chainDal = new();

        public EvolutionFamilyMember() { }

        public EvolutionFamilyMember(int id, int? pokemonEvolutionId, string name, string? gender, string? heldItem,
                                     string? item, string? knownMove, string? knownMoveType, string? location,
                                     int? minAffection, int? minBeauty, int? minHappiness, int? minLevel,
                                     bool needsOverworldRain, string? partySpecies, string? partyType,
                                     string? relativePhysicalStats, string? timeOfDay, string? tradeSpecies,
                                     string? evolutionTrigger, bool turnUpsideDown, int evolutionChainId)
        {
            Id = id;
            PokemonEvolutionId = pokemonEvolutionId;
            Name = name;
            Gender = gender;
            HeldItem = heldItem;
            Item = item;
            KnownMove = knownMove;
            KnownMoveType = knownMoveType;
            Location = location;
            MinAffection = minAffection;
            MinBeauty = minBeauty;
            MinHappiness = minHappiness;
            MinLevel = minLevel;
            NeedsOverworldRain = needsOverworldRain;
            PartySpecies = partySpecies;
            PartyType = partyType;
            RelativePhysicalStats = relativePhysicalStats;
            TimeOfDay = timeOfDay;
            TradeSpecies = tradeSpecies;
            EvolutionTrigger = evolutionTrigger;
            TurnUpsideDown = turnUpsideDown;
            EvolutionChainId = evolutionChainId;
        }

        public EvolutionChain Chain => _chain ??= _chainDal.GetById(EvolutionChainId);
    }
}
