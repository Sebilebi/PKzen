-- Habilitar claves foráneas
PRAGMA foreign_keys = ON;

---------------------------------------------------------------------------
-- 1) DROP TABLE IF EXISTS (de hijos a padres)
---------------------------------------------------------------------------

DROP TABLE IF EXISTS PokemonStat;
DROP TABLE IF EXISTS StatChange;
DROP TABLE IF EXISTS Move;
DROP TABLE IF EXISTS Sprite;
DROP TABLE IF EXISTS Cries;
DROP TABLE IF EXISTS DamageRelation;
DROP TABLE IF EXISTS SpeciesEggGroup;
DROP TABLE IF EXISTS SpeciesType;
DROP TABLE IF EXISTS EvolutionFamilyMember;
DROP TABLE IF EXISTS EvolutionChain;
DROP TABLE IF EXISTS Variety;
DROP TABLE IF EXISTS Pokemon;
DROP TABLE IF EXISTS EggGroup;
DROP TABLE IF EXISTS Ability;
DROP TABLE IF EXISTS Stat;
DROP TABLE IF EXISTS Type;
DROP TABLE IF EXISTS Species;

---------------------------------------------------------------------------
-- 2) CREAR TABLAS
---------------------------------------------------------------------------

-- Tabla de tipos
CREATE TABLE Type (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL
);

-- Tabla Species
CREATE TABLE Species (
    Id INTEGER PRIMARY KEY,
    BaseHappiness INTEGER NOT NULL,
    CaptureRate INTEGER NOT NULL,
    Color TEXT NOT NULL,
    FlavorText TEXT,
    FormsSwitchable BOOLEAN NOT NULL,
    GenderRate INTEGER NOT NULL,
    Genera TEXT,
    Generation TEXT,
    Habitat TEXT,
    HasGenderDifferences BOOLEAN NOT NULL,
    HatchCounter INTEGER NOT NULL,
    IsBaby BOOLEAN NOT NULL,
    IsLegendary BOOLEAN NOT NULL,
    IsMythical BOOLEAN NOT NULL
);

-- Tabla Ability
CREATE TABLE Ability (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Description TEXT,
    IsHidden BOOLEAN NOT NULL
);

-- Tabla Pokémon
CREATE TABLE Pokemon (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    BaseExperience INTEGER NOT NULL,
    Weight INTEGER NOT NULL,
    Height INTEGER NOT NULL,
    IsShiny BOOLEAN NOT NULL,
    Gender TEXT,
    SpeciesId INTEGER NOT NULL,
    AbilityId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE,
    FOREIGN KEY (AbilityId) REFERENCES Ability(Id) ON DELETE CASCADE
);

-- Tabla EggGroup
CREATE TABLE EggGroup (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL
);

-- Join N:N entre Species y EggGroup
CREATE TABLE SpeciesEggGroup (
    SpeciesId INTEGER NOT NULL,
    EggGroupId INTEGER NOT NULL,
    PRIMARY KEY (SpeciesId, EggGroupId),
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE,
    FOREIGN KEY (EggGroupId) REFERENCES EggGroup(Id) ON DELETE CASCADE
);

-- Tabla SpeciesType
CREATE TABLE SpeciesType (
    Id INTEGER PRIMARY KEY,
    Slot INTEGER NOT NULL,
    SpeciesId INTEGER NOT NULL,
    TypeId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE,
    FOREIGN KEY (TypeId) REFERENCES Type(Id) ON DELETE CASCADE
);

-- Tabla DamageRelation
CREATE TABLE DamageRelation (
    SpeciesId INTEGER NOT NULL,
    TypeId INTEGER NOT NULL,
    RelationType REAL NOT NULL,  -- valor multiplicador: 0.25,0.5,1,2,4
    PRIMARY KEY (SpeciesId, TypeId),
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE,
    FOREIGN KEY (TypeId) REFERENCES Type(Id) ON DELETE CASCADE
);

-- Tabla Cries
CREATE TABLE Cries (
    Id INTEGER PRIMARY KEY,
    Latest TEXT,
    Legacy TEXT,
    SpeciesId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE
);

-- Tabla Sprites
CREATE TABLE Sprite (
    Id INTEGER PRIMARY KEY,
    Name TEXT,
    Icon BOOLEAN NOT NULL,
    BackMale TEXT,
    BackFemale TEXT,
    BackShiny TEXT,
    BackShinyFemale TEXT,
    FrontMale TEXT,
    FrontFemale TEXT,
    FrontShiny TEXT,
    FrontShinyFemale TEXT,
    SpeciesId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE
);

-- Tabla Stat
CREATE TABLE Stat (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL
);

-- Tabla PokemonStat
CREATE TABLE PokemonStat (
    Id INTEGER PRIMARY KEY,
    BaseStat INTEGER NOT NULL,
    Effort INTEGER NOT NULL,
    PokemonId INTEGER NOT NULL,
    StatId INTEGER NOT NULL,
    FOREIGN KEY (PokemonId) REFERENCES Pokemon(Id) ON DELETE CASCADE,
    FOREIGN KEY (StatId) REFERENCES Stat(Id) ON DELETE CASCADE
);

-- Tabla Move
CREATE TABLE Move (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Accuracy INTEGER,
    DamageClass TEXT,
    EffectChance INTEGER,
    EffectText TEXT,
    CritRate INTEGER NOT NULL,
    Drain INTEGER NOT NULL,
    FlinchChance INTEGER NOT NULL,
    Healing INTEGER NOT NULL,
    MaxHits INTEGER,
    MaxTurns INTEGER,
    MinHits INTEGER,
    MinTurns INTEGER,
    StatChance INTEGER NOT NULL,
    Power INTEGER,
    Pp INTEGER NOT NULL,
    Priority INTEGER NOT NULL,
    Target TEXT,
    TypeId INTEGER NOT NULL,
    PokemonId INTEGER NOT NULL,
    FOREIGN KEY (TypeId) REFERENCES Type(Id) ON DELETE CASCADE,
    FOREIGN KEY (PokemonId) REFERENCES Pokemon(Id) ON DELETE CASCADE
);

-- Tabla StatChange
CREATE TABLE StatChange (
    Id INTEGER PRIMARY KEY,
    Change INTEGER NOT NULL,
    StatId INTEGER NOT NULL,
    MoveId INTEGER NOT NULL,
    FOREIGN KEY (StatId) REFERENCES Stat(Id) ON DELETE CASCADE,
    FOREIGN KEY (MoveId) REFERENCES Move(Id) ON DELETE CASCADE
);

-- Tabla EvolutionChain
CREATE TABLE EvolutionChain (
    Id INTEGER PRIMARY KEY,
    BabyTriggerItem TEXT,
    SpeciesId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE
);

-- Tabla EvolutionFamilyMember
CREATE TABLE EvolutionFamilyMember (
    Id INTEGER PRIMARY KEY,
    PokemonEvolutionId INTEGER,
    Name TEXT NOT NULL,
    Gender TEXT,
    HeldItem TEXT,
    Item TEXT,
    KnownMove TEXT,
    KnownMoveType TEXT,
    Location TEXT,
    MinAffection INTEGER,
    MinBeauty INTEGER,
    MinHappiness INTEGER,
    MinLevel INTEGER,
    NeedsOverworldRain BOOLEAN,
    PartySpecies TEXT,
    PartyType TEXT,
    RelativePhysicalStats TEXT,
    TimeOfDay TEXT,
    TradeSpecies TEXT,
    EvolutionTrigger TEXT,
    TurnUpsideDown BOOLEAN,
    EvolutionChainId INTEGER NOT NULL,
    FOREIGN KEY (EvolutionChainId) REFERENCES EvolutionChain(Id) ON DELETE CASCADE
);

-- Tabla Variety
CREATE TABLE Variety (
    Id INTEGER PRIMARY KEY,
    IsDefault BOOLEAN NOT NULL,
    Name TEXT NOT NULL,
    SpeciesId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE
);

---------------------------------------------------------------------------
-- 3) DATOS DE EJEMPLO
---------------------------------------------------------------------------

-- Types
INSERT INTO Type (Id, Name) VALUES
  (1, 'grass'),
  (2, 'poison'),
  (3, 'fire'),
  (4, 'ice'),
  (5, 'flying'),
  (6, 'psychic'),
  (7, 'water'),
  (8, 'electric'),
  (9, 'fighting'),
  (10,'fairy');

-- Species
INSERT INTO Species
  (Id, BaseHappiness, CaptureRate, Color, FlavorText, FormsSwitchable,
   GenderRate, Genera, Generation, Habitat, HasGenderDifferences,
   HatchCounter, IsBaby, IsLegendary, IsMythical)
VALUES
  (1, 50, 45, 'green',
   'La planta florece cuando absorbe energía solar, lo cual le obliga a buscar siempre la luz del sol.',
   1, 1, 'Pokémon Semilla', 'generation-i', 'pradera', 1, 20, 0, 0, 0);

-- Abilities
INSERT INTO Ability (Id, Name, Description, IsHidden) VALUES
  (1, 'overgrow',   'Potencia sus movimientos de tipo Planta cuando le quedan pocos PS.', 0),
  (2, 'chlorophyll','Sube su Velocidad cuando hace sol.',                        1);

-- Pokémon
INSERT INTO Pokemon
  (Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId, AbilityId)
VALUES
  (3, 'venusaur', 263, 1000, 20, 0, 'male', 1, 1);

-- EggGroups
INSERT INTO EggGroup (Id, Name) VALUES
  (1, 'monster'),
  (2, 'plant');

-- Junction SpeciesEggGroup
INSERT INTO SpeciesEggGroup (SpeciesId, EggGroupId) VALUES
  (1,1), (1,2);

-- SpeciesType
INSERT INTO SpeciesType (Id, Slot, SpeciesId, TypeId) VALUES
  (1, 1, 1, 1),
  (2, 2, 1, 2);

-- DamageRelation
INSERT INTO DamageRelation (SpeciesId, TypeId, RelationType) VALUES
  (1, 3, 2.0),   -- fire ×2
  (1, 4, 2.0),   -- ice ×2
  (1, 5, 2.0),   -- flying ×2
  (1, 6, 2.0),   -- psychic ×2
  (1, 7, 0.5),   -- water ×0.5
  (1, 8, 0.5),   -- electric ×0.5
  (1, 9, 0.5),   -- fighting ×0.5
  (1, 10,0.5),   -- fairy ×0.5
  (1, 1, 0.25);  -- grass ×0.25

-- Cries
INSERT INTO Cries (Id, Latest, Legacy, SpeciesId) VALUES
  (1,
   'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/3.ogg',
   'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/3.ogg',
   1);

-- Sprite
INSERT INTO Sprite
  (Id, Name, Icon, BackMale, BackFemale, BackShiny, BackShinyFemale,
   FrontMale, FrontFemale, FrontShiny, FrontShinyFemale, SpeciesId)
VALUES
  (1, 'official_artwork', 0, '', '', '', '',
   'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png',
   '', 
   'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/3.png',
   '',
   1);

-- Stat
INSERT INTO Stat (Id, Name) VALUES
  (1, 'hp'),
  (2, 'attack'),
  (3, 'defense'),
  (4, 'special_attack'),
  (5, 'special_defense'),
  (6, 'speed');

-- PokemonStat
INSERT INTO PokemonStat (Id, BaseStat, Effort, PokemonId, StatId) VALUES
  (1,  80, 0, 3, 1),
  (2,  82, 0, 3, 2),
  (3,  83, 0, 3, 3),
  (4, 100, 2, 3, 4),
  (5, 100, 1, 3, 5),
  (6,  80, 0, 3, 6);

-- Move
INSERT INTO Move
  (Id, Name, Accuracy, DamageClass, EffectChance, EffectText, CritRate,
   Drain, FlinchChance, Healing, MaxHits, MaxTurns, MinHits, MinTurns,
   StatChance, Power, Pp, Priority, Target, TypeId, PokemonId)
VALUES
  (14, 'Danza Espada', NULL, 'Sin Daño', NULL,
   'Baile frenético que aumenta mucho el Ataque.', 0, 0, 0, 0,
   NULL, NULL, NULL, NULL, 0, NULL, 20, 0, 'user', 1, 3);

-- StatChange
INSERT INTO StatChange (Id, Change, StatId, MoveId) VALUES
  (1, 2, 2, 14);

-- Evolución
INSERT INTO EvolutionChain (Id, BabyTriggerItem, SpeciesId) VALUES (1, NULL, 1);
INSERT INTO EvolutionFamilyMember
  (Id, PokemonEvolutionId, Name, Gender, HeldItem, Item, KnownMove,
   KnownMoveType, Location, MinAffection, MinBeauty, MinHappiness,
   MinLevel, NeedsOverworldRain, PartySpecies, PartyType,
   RelativePhysicalStats, TimeOfDay, TradeSpecies, EvolutionTrigger,
   TurnUpsideDown, EvolutionChainId)
VALUES
  (1, 1, 'bulbasaur', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 1),
  (2, 2, 'ivysaur',   NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 1),
  (3, 3, 'venusaur',  NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);

-- Variety
INSERT INTO Variety (Id, IsDefault, Name, SpeciesId) VALUES
  (1, 1, 'venusaur',     1),
  (2, 0, 'venusaur-mega',1),
  (3, 0, 'venusaur-gmax',1);
