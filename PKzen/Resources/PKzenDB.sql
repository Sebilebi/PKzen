-- Habilitar claves foráneas
PRAGMA foreign_keys = ON;

---------------------------------------------------------------------------
-- 1) DROP TABLE IF EXISTS (de hijos a padres)
---------------------------------------------------------------------------
DROP TABLE IF EXISTS PokemonAbility;
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

-- Tabla Ability (añadido IsSelected)
CREATE TABLE Ability (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Description TEXT,
    IsHidden BOOLEAN NOT NULL,
    IsSelected BOOLEAN NOT NULL DEFAULT 0
);

-- Tabla Pokémon (quitado AbilityId)
CREATE TABLE Pokemon (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    BaseExperience INTEGER NOT NULL,
    Weight INTEGER NOT NULL,
    Height INTEGER NOT NULL,
    IsShiny BOOLEAN NOT NULL,
    Gender TEXT,
    SpeciesId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE
);

-- Tabla intermedia PokemonAbility (N:N)
CREATE TABLE PokemonAbility (
    PokemonId INTEGER NOT NULL,
    AbilityId INTEGER NOT NULL,
    PRIMARY KEY (PokemonId, AbilityId),
    FOREIGN KEY (PokemonId) REFERENCES Pokemon(Id) ON DELETE CASCADE,
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
    RelationType REAL NOT NULL,
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
  (1, 'normal'),
  (2, 'fighting'),
  (3, 'flying'),
  (4, 'poison'),
  (5, 'ground'),
  (6, 'rock'),
  (7, 'bug'),
  (8, 'ghost'),
  (9, 'steel'),
  (10, 'fire'),
  (11, 'water'),
  (12, 'grass'),
  (13, 'electric'),
  (14, 'psychic'),
  (15, 'ice'),
  (16, 'dragon'),
  (17, 'dark'),
  (18, 'fairy');

-- EggGroups
INSERT INTO EggGroup (Id, Name) VALUES
  (1, 'monster'),
  (2, 'water1'),
  (3, 'bug'),
  (4, 'flying'),
  (5, 'ground'),
  (6, 'fairy'),
  (7, 'plant'),
  (8, 'humanshape'),
  (9, 'water3'),
  (10, 'mineral'),
  (11, 'indeterminate'),
  (12, 'water2'),
  (13, 'ditto'),
  (14, 'dragon'),
  (15, 'no-eggs');

-- Stats
INSERT INTO Stat (Id, Name) VALUES
  (1, 'HP'),
  (2, 'Attack'),
  (3, 'Defense'),
  (4, 'Sp. Atk'),
  (5, 'Sp. Def'),
  (6, 'Speed');

-- Species
INSERT INTO Species (Id, BaseHappiness, CaptureRate, Color, FlavorText, FormsSwitchable, GenderRate, Genera, Generation, Habitat, HasGenderDifferences, HatchCounter, IsBaby, IsLegendary, IsMythical) VALUES
  (1, 50, 45, 'green', 'La semilla de su lomo está llena de nutrientes. La semilla brota a medida que el Pokémon crece.', 0, 1, 'Pokémon Semilla', 'generation-i', 'grassland', 0, 20, 0, 0, 0),
  (2, 50, 45, 'green', 'Cuando le crece bastante el bulbo del lomo, pierde la capacidad de erguirse sobre sus patas traseras.', 0, 1, 'Pokémon Semilla', 'generation-i', 'grassland', 0, 20, 0, 0, 0),
  (3, 50, 45, 'green', 'La planta florece cuando absorbe energía solar, lo cual le obliga a buscar siempre la luz del sol.', 0, 1, 'Pokémon Semilla', 'generation-i', 'grassland', 1, 20, 0, 0, 0),
  (4, 50, 45, 'red', 'Prefiere las cosas calientes. Dicen que cuando llueve le sale vapor de la punta de la cola.', 0, 1, 'Pokémon Lagartija', 'generation-i', 'mountain', 0, 20, 0, 0, 0),
  (5, 50, 45, 'red', 'Este Pokémon de naturaleza agresiva ataca con su cola llameante y corta con sus afiladas garras.', 0, 1, 'Pokémon Llama', 'generation-i', 'mountain', 0, 20, 0, 0, 0),
  (6, 50, 45, 'red', 'Escupe un fuego tan caliente que funde las rocas. Causa incendios forestales sin querer.', 0, 1, 'Pokémon Llama', 'generation-i', 'mountain', 0, 20, 0, 0, 0),
  (7, 50, 45, 'blue', 'Cuando retrae su largo cuello en el caparazón, dispara agua con increíble precisión.', 0, 1, 'Pokémon Tortuguita', 'generation-i', 'waters-edge', 0, 20, 0, 0, 0),
  (8, 50, 45, 'blue', 'Es reconocido como un símbolo de longevidad. Si su caparazón se recubre de algas, significa que es muy viejo.', 0, 1, 'Pokémon Tortuga', 'generation-i', 'waters-edge', 0, 20, 0, 0, 0),
  (9, 50, 45, 'blue', 'Aplasta a sus rivales con su pesado cuerpo para que pierdan el conocimiento. Aguanta ataques con su sólido caparazón.', 0, 1, 'Pokémon Marisco', 'generation-i', 'waters-edge', 0, 20, 0, 0, 0),
  (10, 50, 255, 'green', 'Para protegerse, libera un hedor horrible por las antenas que repele a sus enemigos.', 0, 1, 'Pokémon Gusano', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (11, 50, 120, 'green', 'Aunque está encerrado en un capullo, puede moverse. Es la prueba de que se prepara para su evolución.', 0, 1, 'Pokémon Capullo', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (12, 50, 45, 'white', 'Aletea a gran velocidad para lanzar al aire sus escamas extremadamente tóxicas.', 0, 1, 'Pokémon Mariposa', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (13, 50, 255, 'brown', 'Le gusta el polvo. Usa el polvo de sus alas para defenderse. También puede entrar por las ventanas de las casas para robar miel de las despensas.', 0, 1, 'Pokémon Gusano', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (14, 50, 120, 'yellow', 'Casi incapaz de moverse, este Pokémon solo puede endurecer su caparazón para protegerse.', 0, 1, 'Pokémon Capullo', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (15, 50, 45, 'yellow', 'Tiene tres aguijones venenosos en las patas delanteras y en el abdomen, con los que ataca a sus enemigos una y otra vez.', 0, 1, 'Pokémon Abeja Venenosa', 'generation-i', 'forest', 1, 15, 0, 0, 0),
  (16, 50, 255, 'brown', 'Suele quedarse en las zonas con hierba. Si es amenazado, prefiere correr antes que luchar.', 0, 1, 'Pokémon Pajarito', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (17, 50, 120, 'brown', 'Protege su territorio con tenacidad y ahuyenta a sus enemigos a picotazos.', 0, 1, 'Pokémon Pájaro', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (18, 50, 45, 'brown', 'Este Pokémon vuela a una velocidad de 2 Mach en busca de presas. Sus grandes garras son armas temibles.', 0, 1, 'Pokémon Pájaro', 'generation-i', 'forest', 0, 15, 0, 0, 0),
  (19, 50, 255, 'purple', 'Muerde cualquier cosa cuando ataca. Pequeño y muy rápido, es muy fácil de ver en cualquier sitio.', 0, 1, 'Pokémon Ratón', 'generation-i', 'grassland', 1, 15, 0, 0, 0),
  (20, 50, 127, 'brown', 'Sus robustos colmillos crecen durante toda su vida, por lo que debe roer cosas duras para limarlos.', 0, 1, 'Pokémon Ratón', 'generation-i', 'grassland', 1, 15, 0, 0, 0);

-- Pokemon
INSERT INTO Pokemon (Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId) VALUES
  (1, 'bulbasaur', 64, 69, 7, 0, 'male', 1),
  (2, 'ivysaur', 142, 130, 10, 0, 'male', 2),
  (3, 'venusaur', 263, 1000, 20, 0, 'male', 3),
  (4, 'charmander', 62, 85, 6, 0, 'male', 4),
  (5, 'charmeleon', 142, 190, 11, 0, 'male', 5),
  (6, 'charizard', 267, 905, 17, 0, 'male', 6),
  (7, 'squirtle', 63, 90, 5, 0, 'male', 7),
  (8, 'wartortle', 142, 225, 10, 0, 'male', 8),
  (9, 'blastoise', 265, 855, 16, 0, 'male', 9),
  (10, 'caterpie', 39, 29, 3, 0, 'male', 10),
  (11, 'metapod', 72, 99, 7, 0, 'male', 11),
  (12, 'butterfree', 198, 320, 11, 0, 'male', 12),
  (13, 'weedle', 39, 32, 3, 0, 'male', 13),
  (14, 'kakuna', 72, 100, 6, 0, 'male', 14),
  (15, 'beedrill', 178, 295, 10, 0, 'male', 15),
  (16, 'pidgey', 50, 18, 3, 0, 'male', 16),
  (17, 'pidgeotto', 122, 300, 11, 0, 'male', 17),
  (18, 'pidgeot', 216, 395, 15, 0, 'male', 18),
  (19, 'rattata', 51, 35, 3, 0, 'male', 19),
  (20, 'raticate', 145, 185, 7, 0, 'male', 20);

-- Abilities
INSERT INTO Ability (Id, Name, Description, IsHidden, IsSelected) VALUES
  (1, 'overgrow', 'Potencia sus movimientos de tipo Planta cuando le quedan pocos PS.', 0, 1),
  (2, 'chlorophyll', 'Sube su Velocidad cuando hace sol.', 1, 0),
  (3, 'blaze', 'Potencia sus movimientos de tipo Fuego cuando le quedan pocos PS.', 0, 1),
  (4, 'solar-power', 'Aumenta el Ataque Especial pero reduce los PS cuando hace sol.', 1, 0),
  (5, 'torrent', 'Potencia sus movimientos de tipo Agua cuando le quedan pocos PS.', 0, 1),
  (6, 'rain-dish', 'Recupera PS cuando llueve.', 1, 0),
  (7, 'shield-dust', 'Bloquea los efectos secundarios de los ataques recibidos.', 0, 1),
  (8, 'run-away', 'Permite huir siempre de combates salvajes.', 0, 1),
  (9, 'shed-skin', 'Puede curar sus problemas de estado al cambiar de turno.', 1, 0),
  (10, 'compound-eyes', 'Aumenta la precisión de los movimientos.', 0, 1),
  (11, 'tinted-lens', 'Potencia los movimientos poco eficaces.', 1, 0),
  (12, 'swarm', 'Potencia sus movimientos de tipo Bicho cuando le quedan pocos PS.', 0, 1),
  (13, 'sniper', 'Potencia los golpes críticos.', 1, 0),
  (14, 'keen-eye', 'Evita que baje la precisión.', 0, 1),
  (15, 'tangled-feet', 'Sube la evasión si está confuso.', 0, 1),
  (16, 'big-pecks', 'Evita que baje la Defensa.', 1, 0),
  (17, 'guts', 'Aumenta el Ataque si tiene un problema de estado.', 0, 1),
  (18, 'hustle', 'Aumenta el Ataque pero reduce la precisión.', 0, 1),
  (19, 'intimidate', 'Baja el Ataque del rival al entrar en combate.', 0, 1),
  (20, 'unnerve', 'Impide que los rivales consuman bayas.', 1, 0),
  (21, 'static', 'Puede paralizar al contacto.', 0, 1),
  (22, 'lightning-rod', 'Atrae los movimientos de tipo Eléctrico y sube el Ataque Especial.', 1, 0);

-- PokemonAbility
INSERT INTO PokemonAbility (PokemonId, AbilityId) VALUES
-- Bulbasaur
(1, 1), -- Overgrow (normal)
(1, 2), -- Chlorophyll (oculta)

-- Ivysaur
(2, 1), -- Overgrow (normal)
(2, 2), -- Chlorophyll (oculta)

-- Venusaur
(3, 1), -- Overgrow (normal)
(3, 2), -- Chlorophyll (oculta)

-- Charmander
(4, 3), -- Blaze (normal)
(4, 4), -- Solar Power (oculta)

-- Charmeleon
(5, 3), -- Blaze (normal)
(5, 4), -- Solar Power (oculta)

-- Charizard
(6, 3), -- Blaze (normal)
(6, 4), -- Solar Power (oculta)

-- Squirtle
(7, 5), -- Torrent (normal)
(7, 6), -- Rain Dish (oculta)

-- Wartortle
(8, 5), -- Torrent (normal)
(8, 6), -- Rain Dish (oculta)

-- Blastoise
(9, 5), -- Torrent (normal)
(9, 6), -- Rain Dish (oculta)

-- Caterpie
(10, 7), -- Shield Dust (normal)
(10, 9), -- Run Away (oculta)

-- Metapod
(11, 7), -- Shield Dust (normal)

-- Butterfree
(12, 10), -- Compound Eyes (normal)
(12, 11), -- Tinted Lens (oculta)

-- Weedle
(13, 7), -- Shield Dust (normal)
(13, 9), -- Run Away (oculta)

-- Kakuna
(14, 7), -- Shield Dust (normal)

-- Beedrill
(15, 12), -- Swarm (normal)
(15, 13), -- Sniper (oculta)

-- Pidgey
(16, 14), -- Keen Eye (normal)
(16, 15), -- Tangled Feet (normal)
(16, 16), -- Big Pecks (oculta)

-- Pidgeotto
(17, 14), -- Keen Eye (normal)
(17, 15), -- Tangled Feet (normal)
(17, 16), -- Big Pecks (oculta)

-- Pidgeot
(18, 14), -- Keen Eye (normal)
(18, 15), -- Tangled Feet (normal)
(18, 16), -- Big Pecks (oculta)

-- Rattata
(19, 8), -- Run Away (normal)
(19, 17), -- Guts (normal)
(19, 18), -- Hustle (oculta)

-- Raticate
(20, 19), -- Intimidate (normal)
(20, 8), -- Run Away (normal)
(20, 20); -- Unnerve (oculta)

-- SpeciesEggGroup
INSERT INTO SpeciesEggGroup (SpeciesId, EggGroupId) VALUES
  (1, 1), (1, 7),
  (2, 1), (2, 7),
  (3, 1), (3, 7),
  (4, 1), (4, 14),
  (5, 1), (5, 14),
  (6, 1), (6, 14),
  (7, 1), (7, 2),
  (8, 1), (8, 2),
  (9, 1), (9, 2),
  (10, 3),
  (11, 3),
  (12, 3),
  (13, 3),
  (14, 3),
  (15, 3),
  (16, 4),
  (17, 4),
  (18, 4),
  (19, 5),
  (20, 5);

-- SpeciesType
INSERT INTO SpeciesType (Id, Slot, SpeciesId, TypeId) VALUES
  (1, 1, 1, 12), -- Bulbasaur: Grass
  (2, 2, 1, 4),  -- Bulbasaur: Poison
  (3, 1, 2, 12), -- Ivysaur: Grass
  (4, 2, 2, 4),  -- Ivysaur: Poison
  (5, 1, 3, 12), -- Venusaur: Grass
  (6, 2, 3, 4),  -- Venusaur: Poison
  (7, 1, 4, 10), -- Charmander: Fire
  (8, 1, 5, 10), -- Charmeleon: Fire
  (9, 1, 6, 10), -- Charizard: Fire
  (10, 2, 6, 3), -- Charizard: Flying
  (11, 1, 7, 11), -- Squirtle: Water
  (12, 1, 8, 11), -- Wartortle: Water
  (13, 1, 9, 11), -- Blastoise: Water
  (14, 1, 10, 7), -- Caterpie: Bug
  (15, 1, 11, 7), -- Metapod: Bug
  (16, 1, 12, 7), -- Butterfree: Bug
  (17, 2, 12, 3), -- Butterfree: Flying
  (18, 1, 13, 7), -- Weedle: Bug
  (19, 2, 13, 4), -- Weedle: Poison
  (20, 1, 14, 7), -- Kakuna: Bug
  (21, 2, 14, 4), -- Kakuna: Poison
  (22, 1, 15, 7), -- Beedrill: Bug
  (23, 2, 15, 4), -- Beedrill: Poison
  (24, 1, 16, 1), -- Pidgey: Normal
  (25, 2, 16, 3), -- Pidgey: Flying
  (26, 1, 17, 1), -- Pidgeotto: Normal
  (27, 2, 17, 3), -- Pidgeotto: Flying
  (28, 1, 18, 1), -- Pidgeot: Normal
  (29, 2, 18, 3), -- Pidgeot: Flying
  (30, 1, 19, 1), -- Rattata: Normal
  (31, 1, 20, 1); -- Raticate: Normal

-- DamageRelation
INSERT INTO DamageRelation (SpeciesId, TypeId, RelationType) VALUES
  -- Bulbasaur, Ivysaur, Venusaur (Grass/Poison)
  (1, 10, 2.0), (1, 3, 2.0), (1, 14, 2.0), (1, 15, 2.0), -- Debilidades
  (1, 11, 0.5), (1, 12, 0.5), (1, 2, 0.5), (1, 4, 0.5), -- Resistencias
  (2, 10, 2.0), (2, 3, 2.0), (2, 14, 2.0), (2, 15, 2.0),
  (2, 11, 0.5), (2, 12, 0.5), (2, 2, 0.5), (2, 4, 0.5),
  (3, 10, 2.0), (3, 3, 2.0), (3, 14, 2.0), (3, 15, 2.0),
  (3, 11, 0.5), (3, 12, 0.5), (3, 2, 0.5), (3, 4, 0.5),
  
  -- Charmander, Charmeleon (Fire)
  (4, 11, 2.0), (4, 5, 2.0), (4, 6, 2.0),
  (4, 10, 0.5), (4, 12, 0.5), (4, 7, 0.5), (4, 9, 0.5), (4, 18, 0.5),
  (5, 11, 2.0), (5, 5, 2.0), (5, 6, 2.0),
  (5, 10, 0.5), (5, 12, 0.5), (5, 7, 0.5), (5, 9, 0.5), (5, 18, 0.5),
  
  -- Charizard (Fire/Flying)
  (6, 11, 2.0), (6, 13, 2.0), (6, 6, 4.0),
  (6, 10, 0.5), (6, 2, 0.5), (6, 7, 0.25), (6, 12, 0.25), (6, 18, 0.5),
  
  -- Squirtle, Wartortle, Blastoise (Water)
  (7, 12, 2.0), (7, 13, 2.0),
  (7, 10, 0.5), (7, 11, 0.5), (7, 15, 0.5), (7, 9, 0.5),
  (8, 12, 2.0), (8, 13, 2.0),
  (8, 10, 0.5), (8, 11, 0.5), (8, 15, 0.5), (8, 9, 0.5),
  (9, 12, 2.0), (9, 13, 2.0),
  (9, 10, 0.5), (9, 11, 0.5), (9, 15, 0.5), (9, 9, 0.5);

-- Cries
INSERT INTO Cries (Id, Latest, Legacy, SpeciesId) VALUES
  (1, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/1.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/1.ogg', 1),
  (2, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/2.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/2.ogg', 2),
  (3, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/3.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/3.ogg', 3),
  (4, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/4.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/4.ogg', 4),
  (5, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/5.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/5.ogg', 5),
  (6, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/6.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/6.ogg', 6),
  (7, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/7.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/7.ogg', 7),
  (8, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/8.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/8.ogg', 8),
  (9, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/9.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/9.ogg', 9),
  (10, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/10.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/10.ogg', 10),
  (11, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/11.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/11.ogg', 11),
  (12, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/12.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/12.ogg', 12),
  (13, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/13.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/13.ogg', 13),
  (14, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/14.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/14.ogg', 14),
  (15, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/15.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/15.ogg', 15),
  (16, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/16.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/16.ogg', 16),
  (17, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/17.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/17.ogg', 17),
  (18, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/18.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/18.ogg', 18),
  (19, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/19.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/19.ogg', 19),
  (20, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/20.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/20.ogg', 20);

-- Sprites
INSERT INTO Sprite (Id, Name, Icon, BackMale, BackFemale, BackShiny, BackShinyFemale, FrontMale, FrontFemale, FrontShiny, FrontShinyFemale, SpeciesId) VALUES
  (1, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/1.png', '', 1),
  (2, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/1.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/1.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/1.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/1.png', '', 1),
  (3, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/1.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/1.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/1.gif', '', 1),
  (4, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/2.png', '', 2),
  (5, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/2.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/2.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/2.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/2.png', '', 2),
  (6, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/2.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/2.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/2.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/2.gif', '', 2),
  (7, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/3.png', '', 3),
  (8, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/female/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/female/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/female/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/female/3.png', 3),
  (9, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/3.gif', 3),
  (10, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/4.png', '', 4),
  (11, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/4.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/4.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/4.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/4.png', '', 4),
  (12, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/4.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/4.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/4.gif', '', 4),
  (13, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/5.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/5.png', '', 5),
  (14, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/5.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/5.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/5.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/5.png', '', 5),
  (15, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/5.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/5.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/5.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/5.gif', '', 5),
  (16, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/6.png', '', 6),
  (17, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/6.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/6.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/6.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/6.png', '', 6),
  (18, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/6.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/6.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/6.gif', '', 6),
  (19, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/7.png', '', 7),
  (20, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/7.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/7.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/7.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/7.png', '', 7),
  (21, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/7.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/7.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/7.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/7.gif', '', 7),
  (22, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/8.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/8.png', '', 8),
  (23, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/8.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/8.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/8.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/8.png', '', 8),
  (24, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/8.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/8.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/8.gif', '', 8),
  (25, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/9.png', '', 9),
  (26, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/9.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/9.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/9.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/9.png', '', 9),
  (27, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/9.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/9.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/9.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/9.gif', '', 9),
  (28, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/10.png', '', 10),
  (29, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/10.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/10.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/10.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/10.png', '', 10),
  (30, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/10.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/10.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/10.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/10.gif', '', 10),
  (31, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/11.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/11.png', '', 11),
  (32, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/11.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/11.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/11.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/11.png', '', 11),
  (33, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/11.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/11.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/11.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/11.gif', '', 11),
  (34, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/12.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/12.png', '', 12),
  (35, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/12.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/12.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/12.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/12.png', '', 12),
  (36, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/12.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/12.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/12.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/12.gif', '', 12),
  (37, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/13.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/13.png', '', 13),
  (38, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/13.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/13.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/13.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/13.png', '', 13),
  (39, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/13.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/13.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/13.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/13.gif', '', 13),
  (40, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/14.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/14.png', '', 14),
  (41, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/14.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/14.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/14.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/14.png', '', 14),
  (42, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/14.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/14.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/14.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/14.gif', '', 14),
  (43, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/15.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/15.png', '', 15),
  (44, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/15.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/15.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/15.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/15.png', '', 15),
  (45, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/15.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/15.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/15.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/15.gif', '', 15),
  (46, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/16.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/16.png', '', 16),
  (47, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/16.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/16.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/16.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/16.png', '', 16),
  (48, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/16.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/16.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/16.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/16.gif', '', 16),
  (49, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/17.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/17.png', '', 17),
  (50, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/17.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/17.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/17.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/17.png', '', 17),
  (51, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/17.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/17.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/17.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/17.gif', '', 17),
  (52, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/18.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/18.png', '', 18),
  (53, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/18.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/18.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/18.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/18.png', '', 18),
  (54, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/18.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/18.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/18.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/18.gif', '', 18),
  (55, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/19.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/19.png', '', 19),
  (56, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/19.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/19.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/19.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/19.png', '', 19),
  (57, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/19.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/19.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/19.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/19.gif', '', 19),
  (58, 'official_artwork', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/20.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/20.png', '', 20),
  (59, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/20.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/back/shiny/20.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/20.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/shiny/20.png', '', 20),
  (60, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/20.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/20.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/20.gif', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/20.gif', '', 20);

-- PokemonStat
INSERT INTO PokemonStat (Id, BaseStat, Effort, PokemonId, StatId) VALUES
  -- Bulbasaur
  (1, 45, 0, 1, 1),
  (2, 49, 0, 1, 2),
  (3, 49, 0, 1, 3),
  (4, 65, 1, 1, 4),
  (5, 65, 0, 1, 5),
  (6, 45, 0, 1, 6),
  
  -- Ivysaur
  (7, 60, 0, 2, 1),
  (8, 62, 0, 2, 2),
  (9, 63, 0, 2, 3),
  (10, 80, 1, 2, 4),
  (11, 80, 1, 2, 5),
  (12, 60, 0, 2, 6),
  
  -- Venusaur
  (13, 80, 0, 3, 1),
  (14, 82, 0, 3, 2),
  (15, 83, 0, 3, 3),
  (16, 100, 2, 3, 4),
  (17, 100, 1, 3, 5),
  (18, 80, 0, 3, 6),
  
  -- Charmander
  (19, 39, 0, 4, 1),
  (20, 52, 0, 4, 2),
  (21, 43, 0, 4, 3),
  (22, 60, 0, 4, 4),
  (23, 50, 0, 4, 5),
  (24, 65, 1, 4, 6),
  
  -- Charmeleon
  (25, 58, 0, 5, 1),
  (26, 64, 0, 5, 2),
  (27, 58, 0, 5, 3),
  (28, 80, 1, 5, 4),
  (29, 65, 0, 5, 5),
  (30, 80, 1, 5, 6),
  
  -- Charizard
  (31, 78, 0, 6, 1),
  (32, 84, 0, 6, 2),
  (33, 78, 0, 6, 3),
  (34, 109, 3, 6, 4),
  (35, 85, 0, 6, 5),
  (36, 100, 0, 6, 6),
  
  -- Squirtle
  (37, 44, 0, 7, 1),
  (38, 48, 0, 7, 2),
  (39, 65, 1, 7, 3),
  (40, 50, 0, 7, 4),
  (41, 64, 0, 7, 5),
  (42, 43, 0, 7, 6),
  
  -- Wartortle
  (43, 59, 0, 8, 1),
  (44, 63, 0, 8, 2),
  (45, 80, 1, 8, 3),
  (46, 65, 0, 8, 4),
  (47, 80, 1, 8, 5),
  (48, 58, 0, 8, 6),
  
  -- Blastoise
  (49, 79, 0, 9, 1),
  (50, 83, 0, 9, 2),
  (51, 100, 0, 9, 3),
  (52, 85, 0, 9, 4),
  (53, 105, 3, 9, 5),
  (54, 78, 0, 9, 6),
  
  -- Caterpie
  (55, 45, 1, 10, 1),
  (56, 30, 0, 10, 2),
  (57, 35, 0, 10, 3),
  (58, 20, 0, 10, 4),
  (59, 20, 0, 10, 5),
  (60, 45, 0, 10, 6),
  
  -- Metapod
  (61, 50, 0, 11, 1),
  (62, 20, 0, 11, 2),
  (63, 55, 2, 11, 3),
  (64, 25, 0, 11, 4),
  (65, 25, 0, 11, 5),
  (66, 30, 0, 11, 6),
  
  -- Butterfree
  (67, 60, 0, 12, 1),
  (68, 45, 0, 12, 2),
  (69, 50, 0, 12, 3),
  (70, 90, 2, 12, 4),
  (71, 80, 1, 12, 5),
  (72, 70, 0, 12, 6),
  
  -- Weedle
  (73, 40, 1, 13, 1),
  (74, 35, 0, 13, 2),
  (75, 30, 0, 13, 3),
  (76, 20, 0, 13, 4),
  (77, 20, 0, 13, 5),
  (78, 50, 0, 13, 6),
  
  -- Kakuna
  (79, 45, 0, 14, 1),
  (80, 25, 0, 14, 2),
  (81, 50, 2, 14, 3),
  (82, 25, 0, 14, 4),
  (83, 25, 0, 14, 5),
  (84, 35, 0, 14, 6),
  
  -- Beedrill
  (85, 65, 0, 15, 1),
  (86, 90, 2, 15, 2),
  (87, 40, 0, 15, 3),
  (88, 45, 0, 15, 4),
  (89, 80, 1, 15, 5),
  (90, 75, 0, 15, 6),
  
  -- Pidgey
  (91, 40, 0, 16, 1),
  (92, 45, 0, 16, 2),
  (93, 40, 0, 16, 3),
  (94, 35, 0, 16, 4),
  (95, 35, 0, 16, 5),
  (96, 56, 1, 16, 6),
  
  -- Pidgeotto
  (97, 63, 0, 17, 1),
  (98, 60, 0, 17, 2),
  (99, 55, 0, 17, 3),
  (100, 50, 0, 17, 4),
  (101, 50, 0, 17, 5),
  (102, 71, 2, 17, 6),
  
  -- Pidgeot
  (103, 83, 0, 18, 1),
  (104, 80, 0, 18, 2),
  (105, 75, 0, 18, 3),
  (106, 70, 0, 18, 4),
  (107, 70, 0, 18, 5),
  (108, 101, 3, 18, 6),
  
  -- Rattata
  (109, 30, 0, 19, 1),
  (110, 56, 0, 19, 2),
  (111, 35, 0, 19, 3),
  (112, 25, 0, 19, 4),
  (113, 35, 0, 19, 5),
  (114, 72, 1, 19, 6),
  
  -- Raticate
  (115, 55, 0, 20, 1),
  (116, 81, 0, 20, 2),
  (117, 60, 0, 20, 3),
  (118, 50, 0, 20, 4),
  (119, 70, 0, 20, 5),
  (120, 97, 2, 20, 6);

-- Move
INSERT INTO Move (Id, Name, Accuracy, DamageClass, EffectChance, EffectText, CritRate, Drain, FlinchChance, Healing, MaxHits, MaxTurns, MinHits, MinTurns, StatChance, Power, Pp, Priority, Target, TypeId, PokemonId) VALUES
  -- Bulbasaur
  (1, 'Tackle', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 1, 1),
  (2, 'Growl', 100, 'Status', NULL, 'Reduces the targets Attack by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'all-opponents', 1, 1),
  (3, 'Leech Seed', 90, 'Status', NULL, 'Seeds the target, stealing HP from it every turn.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 10, 0, 'selected-pokemon', 12, 1),
  (4, 'Vine Whip', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 45, 25, 0, 'selected-pokemon', 12, 1),
  
  -- Charmander
  (5, 'Scratch', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 1, 4),
  (6, 'Growl', 100, 'Status', NULL, 'Reduces the targets Attack by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'all-opponents', 1, 4),
  (7, 'Ember', 100, 'Special', 10, 'Has a 10% chance to burn the target.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 25, 0, 'selected-pokemon', 10, 4),
  (8, 'Smokescreen', 100, 'Status', NULL, 'Reduces the targets accuracy by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 20, 0, 'selected-pokemon', 1, 4),
  
  -- Squirtle
  (9, 'Tackle', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 1, 7),
  (10, 'Tail Whip', 100, 'Status', NULL, 'Reduces the targets Defense by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 30, 0, 'all-opponents', 1, 7),
  (11, 'Bubble', 100, 'Special', 10, 'Has a 10% chance to lower the targets Speed by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 30, 0, 'all-opponents', 11, 7),
  (12, 'Withdraw', NULL, 'Status', NULL, 'Raises the users Defense by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'user', 11, 7),
  
  -- Caterpie
  (13, 'Tackle', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 1, 10),
  (14, 'String Shot', 95, 'Status', NULL, 'Lowers the targets Speed by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'all-opponents', 7, 10),
  
  -- Weedle
  (15, 'Poison Sting', 100, 'Physical', 30, 'Has a 30% chance to poison the target.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 15, 35, 0, 'selected-pokemon', 4, 13),
  (16, 'String Shot', 95, 'Status', NULL, 'Lowers the targets Speed by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'all-opponents', 7, 13),
  
  -- Pidgey
  (17, 'Tackle', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 1, 16),
  (18, 'Sand Attack', 100, 'Status', NULL, 'Lowers the targets accuracy by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 15, 0, 'selected-pokemon', 5, 16),
  (19, 'Gust', 100, 'Special', NULL, 'Inflicts regular damage and can hit Pokémon in the air.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 3, 16),
  (20, 'Quick Attack', 100, 'Physical', NULL, 'Inflicts regular damage. User attacks first.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 30, 1, 'selected-pokemon', 1, 16),
  
  -- Rattata
  (21, 'Tackle', 100, 'Physical', NULL, 'Inflicts regular damage with no additional effect.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'selected-pokemon', 1, 19),
  (22, 'Tail Whip', 100, 'Status', NULL, 'Reduces the targets Defense by one stage.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 30, 0, 'all-opponents', 1, 19),
  (23, 'Quick Attack', 100, 'Physical', NULL, 'Inflicts regular damage. User attacks first.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 30, 1, 'selected-pokemon', 1, 19),
  (24, 'Focus Energy', NULL, 'Status', NULL, 'Increases the users chance for a critical hit.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 30, 0, 'user', 1, 19);

-- StatChange
INSERT INTO StatChange (Id, Change, StatId, MoveId) VALUES
  (1, -1, 2, 2),  -- Growl reduces Attack
  (2, -1, 3, 10), -- Tail Whip reduces Defense
  (3, -1, 6, 11), -- Bubble can reduce Speed
  (4, 1, 3, 12),  -- Withdraw increases Defense
  (5, -1, 6, 14), -- String Shot reduces Speed
  (6, -1, 6, 16), -- String Shot reduces Speed
  (7, -1, 6, 18); -- Sand Attack reduces Accuracy

-- EvolutionChain
INSERT INTO EvolutionChain (Id, BabyTriggerItem, SpeciesId) VALUES
  (1, NULL, 1),  -- Bulbasaur line
  (2, NULL, 4),  -- Charmander line
  (3, NULL, 7),  -- Squirtle line
  (4, NULL, 10), -- Caterpie line
  (5, NULL, 13), -- Weedle line
  (6, NULL, 16), -- Pidgey line
  (7, NULL, 19); -- Rattata line

-- EvolutionFamilyMember
INSERT INTO EvolutionFamilyMember (Id, PokemonEvolutionId, Name, Gender, HeldItem, Item, KnownMove, KnownMoveType, Location, MinAffection, MinBeauty, MinHappiness, MinLevel, NeedsOverworldRain, PartySpecies, PartyType, RelativePhysicalStats, TimeOfDay, TradeSpecies, EvolutionTrigger, TurnUpsideDown, EvolutionChainId) VALUES
  -- Bulbasaur line
  (1, 1, 'bulbasaur', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 1),
  (2, 2, 'ivysaur', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 1),
  (3, 3, 'venusaur', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
  
  -- Charmander line
  (4, 4, 'charmander', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 2),
  (5, 5, 'charmeleon', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 2),
  (6, 6, 'charizard', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2),
  
  -- Squirtle line
  (7, 7, 'squirtle', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 3),
  (8, 8, 'wartortle', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 3),
  (9, 9, 'blastoise', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3),
  
  -- Caterpie line
  (10, 10, 'caterpie', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 4),
  (11, 11, 'metapod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 4),
  (12, 12, 'butterfree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4),
  
  -- Weedle line
  (13, 13, 'weedle', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 5),
  (14, 14, 'kakuna', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 5),
  (15, 15, 'beedrill', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5),
  
  -- Pidgey line
  (16, 16, 'pidgey', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 6),
  (17, 17, 'pidgeotto', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 6),
  (18, 18, 'pidgeot', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6),
  
  -- Rattata line
  (19, 19, 'rattata', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 7),
  (20, 20, 'raticate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 7);

-- Variety
INSERT INTO Variety (Id, IsDefault, Name, SpeciesId) VALUES
  (1, 1, 'bulbasaur', 1),
  (2, 1, 'ivysaur', 2),
  (3, 1, 'venusaur', 3),
  (4, 0, 'venusaur-mega', 3),
  (5, 0, 'venusaur-gmax', 3),
  (6, 1, 'charmander', 4),
  (7, 1, 'charmeleon', 5),
  (8, 1, 'charizard', 6),
  (9, 0, 'charizard-mega-x', 6),
  (10, 0, 'charizard-mega-y', 6),
  (11, 0, 'charizard-gmax', 6),
  (12, 1, 'squirtle', 7),
  (13, 1, 'wartortle', 8),
  (14, 1, 'blastoise', 9),
  (15, 0, 'blastoise-mega', 9),
  (16, 0, 'blastoise-gmax', 9),
  (17, 1, 'caterpie', 10),
  (18, 1, 'metapod', 11),
  (19, 1, 'butterfree', 12),
  (20, 0, 'butterfree-gmax', 12),
  (21, 1, 'weedle', 13),
  (22, 1, 'kakuna', 14),
  (23, 1, 'beedrill', 15),
  (24, 0, 'beedrill-mega', 15),
  (25, 1, 'pidgey', 16),
  (26, 1, 'pidgeotto', 17),
  (27, 1, 'pidgeot', 18),
  (28, 0, 'pidgeot-mega', 18),
  (29, 1, 'rattata', 19),
  (30, 0, 'rattata-alola', 19),
  (31, 1, 'raticate', 20),
  (32, 0, 'raticate-alola', 20),
  (33, 0, 'raticate-totem-alola', 20);
  