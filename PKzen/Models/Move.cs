using PKzen.DataAccess;

namespace PKzen.Models
{
    public class Move
    {
        public int Id { get; }
        public string Name { get; }
        public int? Accuracy { get; }
        public string? DamageClass { get; }
        public int? EffectChance { get; }
        public string? EffectText { get; }
        public int CritRate { get; }
        public int Drain { get; }
        public int FlinchChance { get; }
        public int Healing { get; }
        public int? MaxHits { get; }
        public int? MaxTurns { get; }
        public int? MinHits { get; }
        public int? MinTurns { get; }
        public int StatChance { get; }
        public int? Power { get; }
        public int Pp { get; }
        public int Priority { get; }
        public string? Target { get; }
        public int TypeId { get; }
        public int PokemonId { get; }

        private Type? _type;
        private Pokemon? _pokemon;
        private IEnumerable<StatChange>? _statChanges;
        private readonly TypeDal _typeDal = new();
        private readonly PokemonDal _pokemonDal = new();
        private readonly StatChangeDal _statChangeDal = new();

        public Move() { }

        public Move(int id, string name, int? accuracy, string? damageClass, int? effectChance,
                    string? effectText, int critRate, int drain, int flinchChance, int healing,
                    int? maxHits, int? maxTurns, int? minHits, int? minTurns, int statChance,
                    int? power, int pp, int priority, string? target, int typeId, int pokemonId)
        {
            Id = id;
            Name = name;
            Accuracy = accuracy;
            DamageClass = damageClass;
            EffectChance = effectChance;
            EffectText = effectText;
            CritRate = critRate;
            Drain = drain;
            FlinchChance = flinchChance;
            Healing = healing;
            MaxHits = maxHits;
            MaxTurns = maxTurns;
            MinHits = minHits;
            MinTurns = minTurns;
            StatChance = statChance;
            Power = power;
            Pp = pp;
            Priority = priority;
            Target = target;
            TypeId = typeId;
            PokemonId = pokemonId;
        }

        public Type Type => _type ??= _typeDal.GetById(TypeId);
        public Pokemon Pokemon => _pokemon ??= _pokemonDal.GetById(PokemonId);
        public IEnumerable<StatChange> StatChanges => _statChanges ??= _statChangeDal.GetByMoveId(Id);
    }
}
