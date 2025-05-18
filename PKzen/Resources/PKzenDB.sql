-- Habilitar claves foráneas
PRAGMA foreign_keys = ON;

---------------------------------------------------------------------------
-- 1) DROP TABLE IF EXISTS (de hijos a padres)
---------------------------------------------------------------------------

DROP TABLE IF EXISTS SpeciesAbility;
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
    IsHidden BOOLEAN NOT NULL,
    IsSelected BOOLEAN NOT NULL DEFAULT 0
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
    SpeciesId INTEGER NOT NULL,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE
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
    VarietyId INTEGER,
    EvolutionFamilyMemberId INTEGER,
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE,
    FOREIGN KEY (EvolutionFamilyMemberId) REFERENCES EvolutionFamilyMember(Id) ON DELETE SET NULL,
    FOREIGN KEY (VarietyId) REFERENCES Variety(Id) ON DELETE SET NULL
);

-- Tabla intermedia SpeciesAbility
CREATE TABLE SpeciesAbility (
    SpeciesId INTEGER NOT NULL,
    AbilityId INTEGER NOT NULL,
    PRIMARY KEY (SpeciesId, AbilityId),
    FOREIGN KEY (SpeciesId) REFERENCES Species(Id) ON DELETE CASCADE,
    FOREIGN KEY (AbilityId) REFERENCES Ability(Id) ON DELETE CASCADE
);

-- Tabla EggGroup
CREATE TABLE EggGroup (
    Id INTEGER PRIMARY KEY,
    Name TEXT NOT NULL
);

-- Tabla intermedia SpeciesEggGroup
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

---------------------------------------------------------------------------
-- 3) DATOS DE EJEMPLO
---------------------------------------------------------------------------

-- Types
INSERT INTO Type (Id, Name) VALUES
  (1, 'Normal'),
  (2, 'Lucha'),
  (3, 'Volador'),
  (4, 'Veneno'),
  (5, 'Tierra'),
  (6, 'roca'),
  (7, 'bicho'),
  (8, 'fantasma'),
  (9, 'acero'),
  (10, 'fuego'),
  (11, 'agua'),
  (12, 'planta'),
  (13, 'eléctrico'),
  (14, 'psíquico'),
  (15, 'hielo'),
  (16, 'dragón'),
  (17, 'siniestro'),
  (18, 'hada');

-- EggGroups
INSERT INTO EggGroup (Id, Name) VALUES
  (1, 'monstruo'),
  (2, 'agua1'),
  (3, 'bicho'),
  (4, 'volador'),
  (5, 'campo'),
  (6, 'hada'),
  (7, 'planta'),
  (8, 'humanoide'),
  (9, 'agua3'),
  (10, 'mineral'),
  (11, 'amorfo'),
  (12, 'agua2'),
  (13, 'ditto'),
  (14, 'dragón'),
  (15, 'no-huevos');

-- Stats
INSERT INTO Stat (Id, Name) VALUES
  (1, 'PS'),
  (2, 'Ataque'),
  (3, 'Defensa'),
  (4, 'Atq. Esp.'),
  (5, 'Def. Esp.'),
  (6, 'Velocidad');

-- Species
INSERT INTO Species (Id, BaseHappiness, CaptureRate, Color, FlavorText, FormsSwitchable, GenderRate, Genera, Generation, Habitat, HasGenderDifferences, HatchCounter, IsBaby, IsLegendary, IsMythical) VALUES
  (1, 50, 45, 'verde', 'La semilla de su lomo está llena de nutrientes. La semilla brota a medida que el Pokémon crece.', 0, 1, 'Pokémon Semilla', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (2, 50, 45, 'verde', 'Cuando le crece bastante el bulbo del lomo, pierde la capacidad de erguirse sobre sus patas traseras.', 0, 1, 'Pokémon Semilla', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (3, 50, 45, 'verde', 'La planta florece cuando absorbe energía solar, lo cual le obliga a buscar siempre la luz del sol.', 0, 1, 'Pokémon Semilla', 'generation-i', 'pradera', 1, 20, 0, 0, 0),
  (4, 50, 45, 'rojo', 'Prefiere las cosas calientes. Dicen que cuando llueve le sale vapor de la punta de la cola.', 0, 1, 'Pokémon Lagartija', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (5, 50, 45, 'rojo', 'Este Pokémon de naturaleza agresiva ataca con su cola llameante y corta con sus afiladas garras.', 0, 1, 'Pokémon Llama', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (6, 50, 45, 'rojo', 'Escupe un fuego tan caliente que funde las rocas. Causa incendios forestales sin querer.', 0, 1, 'Pokémon Llama', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (7, 50, 45, 'azul', 'Cuando retrae su largo cuello en el caparazón, dispara agua con increíble precisión.', 0, 1, 'Pokémon Tortuguita', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (8, 50, 45, 'azul', 'Es reconocido como un símbolo de longevidad. Si su caparazón se recubre de algas, significa que es muy viejo.', 0, 1, 'Pokémon Tortuga', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (9, 50, 45, 'azul', 'Aplasta a sus rivales con su pesado cuerpo para que pierdan el conocimiento. Aguanta ataques con su sólido caparazón.', 0, 1, 'Pokémon Marisco', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (10, 50, 255, 'verde', 'Para protegerse, libera un hedor horrible por las antenas que repele a sus enemigos.', 0, 1, 'Pokémon Gusano', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (11, 50, 120, 'verde', 'Aunque está encerrado en un capullo, puede moverse. Es la prueba de que se prepara para su evolución.', 0, 1, 'Pokémon Capullo', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (12, 50, 45, 'blanco', 'Aletea a gran velocidad para lanzar al aire sus escamas extremadamente tóxicas.', 0, 1, 'Pokémon Mariposa', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (13, 50, 255, 'marrón', 'Le gusta el polvo. Usa el polvo de sus alas para defenderse. También puede entrar por las ventanas de las casas para robar miel de las despensas.', 0, 1, 'Pokémon Gusano', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (14, 50, 120, 'amarillo', 'Casi incapaz de moverse, este Pokémon solo puede endurecer su caparazón para protegerse.', 0, 1, 'Pokémon Capullo', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (15, 50, 45, 'amarillo', 'Tiene tres aguijones venenosos en las patas delanteras y en el abdomen, con los que ataca a sus enemigos una y otra vez.', 0, 1, 'Pokémon Abeja Venenosa', 'generation-i', 'bosque', 1, 15, 0, 0, 0),
  (16, 50, 255, 'marrón', 'Suele quedarse en las zonas con hierba. Si es amenazado, prefiere correr antes que luchar.', 0, 1, 'Pokémon Pajarito', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (17, 50, 120, 'marrón', 'Protege su territorio con tenacidad y ahuyenta a sus enemigos a picotazos.', 0, 1, 'Pokémon Pájaro', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (18, 50, 45, 'marrón', 'Este Pokémon vuela a una velocidad de 2 Mach en busca de presas. Sus grandes garras son armas temibles.', 0, 1, 'Pokémon Pájaro', 'generation-i', 'bosque', 0, 15, 0, 0, 0),
  (19, 50, 255, 'púrpura', 'Muerde cualquier cosa cuando ataca. Pequeño y muy rápido, es muy fácil de ver en cualquier sitio.', 0, 1, 'Pokémon Ratón', 'generation-i', 'pradera', 1, 15, 0, 0, 0),
  (20, 50, 127, 'marrón', 'Sus robustos colmillos crecen durante toda su vida, por lo que debe roer cosas duras para limarlos.', 0, 1, 'Pokémon Ratón', 'generation-i', 'pradera', 1, 15, 0, 0, 0),
  (21, 50, 255, 'marrón', 'Come insectos en zonas de hierba. Tiene que batir sus cortas alas muy rápido para mantenerse en el aire.', 0, 1, 'Pokémon Pajarito', 'generation-i', 'pradera', 0, 15, 0, 0, 0),
  (22, 50, 90, 'marrón', 'Un Pokémon muy antiguo. Si detecta peligro, vuela alto y lejos con sus espléndidas alas.', 0, 1, 'Pokémon Pico', 'generation-i', 'pradera', 0, 15, 0, 0, 0),
  (23, 50, 255, 'púrpura', 'La lengua bífida se mueve sin parar. Usa los sentidos del olfato y del oído para acechar a sus presas.', 0, 1, 'Pokémon Serpiente', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (24, 50, 90, 'púrpura', 'Se han visto estudios sobre cómo las marcas de su piel varían según el hábitat.', 0, 1, 'Pokémon Cobra', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (25, 50, 190, 'amarillo', 'Cuando se enfada, este Pokémon descarga la energía que almacena en las bolsas de sus mejillas.', 0, 1, 'Pokémon Ratón', 'generation-i', 'bosque', 1, 10, 0, 0, 0),
  (26, 50, 75, 'amarillo', 'Su larga cola le sirve como toma de tierra para protegerse a sí mismo del alto voltaje que genera su cuerpo.', 0, 1, 'Pokémon Ratón', 'generation-i', 'bosque', 1, 10, 0, 0, 0),
  (27, 50, 255, 'amarillo', 'Le gusta revolcarse por la arena seca para eliminar la suciedad que se adhiere a su cuerpo.', 0, 1, 'Pokémon Ratón', 'generation-i', 'desierto', 0, 20, 0, 0, 0),
  (28, 50, 90, 'amarillo', 'Puede rodar formando una bola, encogiendo su cuerpo. Es una buena forma de atravesar terrenos duros.', 0, 1, 'Pokémon Ratón', 'generation-i', 'desierto', 0, 20, 0, 0, 0),
  (29, 50, 235, 'azul', 'Aunque pequeña, su cuerno venenoso es muy peligroso. La hembra tiene un cuerno más pequeño.', 0, 8, 'Pokémon Pin Veneno', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (30, 50, 120, 'azul', 'Cuando está con sus amigos o su familia, esconde sus púas para evitar accidentes.', 0, 8, 'Pokémon Pin Veneno', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (31, 50, 45, 'azul', 'Su cuerpo está recubierto de escamas duras como una piedra. Suele lanzar ataques potentes con su cuerpo macizo.', 0, 8, 'Pokémon Taladro', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (32, 50, 235, 'púrpura', 'Levanta sus grandes orejas para vigilar. Si detecta peligro, ataca con el cuerno tóxico.', 0, 0, 'Pokémon Pin Veneno', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (33, 50, 120, 'púrpura', 'Un Pokémon agresivo que es rápido atacando. El cuerno de su cabeza segrega un potente veneno.', 0, 0, 'Pokémon Pin Veneno', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (34, 50, 45, 'púrpura', 'Usa su poderosa cola en combate para aplastar, apretar y luego romper la columna de su rival.', 0, 0, 'Pokémon Taladro', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (35, 50, 150, 'rosa', 'Su adorable aspecto y su canto cautivador hacen de este Pokémon muy popular. Es raro y solo se encuentra en ciertas áreas.', 0, 6, 'Pokémon Hada', 'generation-i', 'montaña', 0, 10, 0, 0, 0),
  (36, 50, 25, 'rosa', 'Un Pokémon tímido que rara vez se ve. Huye rápidamente si detecta que lo observan.', 0, 6, 'Pokémon Hada', 'generation-i', 'montaña', 0, 10, 0, 0, 0),
  (37, 50, 190, 'marrón', 'Cuando nace, tiene seis colas. Las colas se dividen desde la punta a medida que crece.', 0, 6, 'Pokémon Zorro', 'generation-i', 'pradera', 1, 20, 0, 0, 0),
  (38, 50, 75, 'amarillo', 'Según una leyenda antigua, 9 nobles santos se reencarnaron en este Pokémon. Es muy inteligente y entiende el lenguaje humano.', 0, 6, 'Pokémon Zorro', 'generation-i', 'pradera', 1, 20, 0, 0, 0),
  (39, 50, 170, 'rosa', 'Cuando sus ojos brillan, canta una melodía misteriosa que adormece a sus enemigos.', 0, 6, 'Pokémon Globo', 'generation-i', 'pradera', 1, 10, 0, 0, 0),
  (40, 50, 50, 'rosa', 'Su cuerpo está lleno de elasticidad. Cuando canta una melodía de cuna, todos los que la escuchan se duermen.', 0, 6, 'Pokémon Globo', 'generation-i', 'pradera', 1, 10, 0, 0, 0),
  (41, 50, 255, 'púrpura', 'Forma colonias en lugares oscuros. Usa ultrasonidos para identificar y acercarse a los objetivos.', 0, 1, 'Pokémon Murciélago', 'generation-i', 'cueva', 0, 15, 0, 0, 0),
  (42, 50, 90, 'púrpura', 'Una vez que prueba la sangre, no se detiene hasta que la víctima se queda sin ella. Vuela por la noche en busca de presas.', 0, 1, 'Pokémon Murciélago', 'generation-i', 'cueva', 1, 15, 0, 0, 0),
  (43, 50, 255, 'azul', 'Durante el día, se queda en zonas frías bajo tierra. Se mueve utilizando sus pies, que parecen raíces.', 0, 1, 'Pokémon Hierbajo', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (44, 50, 120, 'azul', 'El pistilo de la flor libera un hedor horrible. Cuando tiene hambre, el olor se vuelve más fuerte.', 0, 1, 'Pokémon Hierbajo', 'generation-i', 'pradera', 1, 20, 0, 0, 0),
  (45, 50, 45, 'rojo', 'Cuanto más grandes son sus pétalos, más tóxico es su polen. Su cabeza puede ser pesada y difícil de mantener erguida.', 0, 1, 'Pokémon Flor', 'generation-i', 'pradera', 1, 20, 0, 0, 0),
  (46, 50, 190, 'rojo', 'Excava bajo tierra para roer las raíces de los árboles. Sus setas rojas brillan en la oscuridad.', 0, 1, 'Pokémon Hongo', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (47, 50, 75, 'rojo', 'Un hongo parásito controla su cuerpo. Prefiere los lugares húmedos y oscuros, como los grandes árboles en bosques densos.', 0, 1, 'Pokémon Hongo', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (48, 50, 190, 'púrpura', 'Sus grandes ojos actúan como radar. En lugares luminosos, puede ver claramente.', 0, 1, 'Pokémon Insecto', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (49, 50, 75, 'púrpura', 'Las escamas de sus alas son resistentes al agua. Puede volar bajo la lluvia sin problemas.', 0, 1, 'Pokémon Polilla Venenosa', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (50, 50, 255, 'marrón', 'Vive a un metro bajo tierra. Se alimenta de raíces. A veces aparece en la superficie.', 0, 1, 'Pokémon Topo', 'generation-i', 'cueva', 0, 20, 0, 0, 0),
  (51, 50, 50, 'marrón', 'Un equipo de tres Diglett. Excava a 100 km/h, provocando terremotos y levantando el terreno.', 0, 1, 'Pokémon Topo', 'generation-i', 'cueva', 0, 20, 0, 0, 0),
  (52, 50, 255, 'amarillo', 'Le encanta coleccionar objetos brillantes. Si está de buen humor, incluso puede mostrar su tesoro a su entrenador.', 0, 1, 'Pokémon Gato Araña', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (53, 50, 90, 'amarillo', 'Un Pokémon muy orgulloso. Ataca con sus garras afiladas. No es fácil ganarse su confianza.', 0, 1, 'Pokémon Gato Fino', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (54, 50, 190, 'amarillo', 'Siempre tiene dolor de cabeza. Cuando es intenso, comienza a mostrar extraños poderes psíquicos.', 0, 1, 'Pokémon Pato', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (55, 50, 75, 'azul', 'Aparece en ríos que fluyen con rapidez. Puede nadar incluso contra corrientes fuertes usando sus patas palmeadas.', 0, 1, 'Pokémon Pato', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (56, 50, 190, 'marrón', 'Se enfada con facilidad. Puede pasar de estar tranquilo a furioso en un instante. Cuando está enfadado, su sangre fluye más rápido.', 0, 1, 'Pokémon Mono Cerdo', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (57, 50, 75, 'marrón', 'Siempre está furioso y tenso. Si se enfada, se vuelve violento con cualquiera que esté cerca, sin importar quién sea.', 0, 1, 'Pokémon Mono Cerdo', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (58, 50, 190, 'marrón', 'Muy leal por naturaleza. Ladrará a cualquier oponente para defender a su entrenador de los daños.', 0, 3, 'Pokémon Perrito', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (59, 50, 75, 'marrón', 'Un Pokémon legendario en China. Se dice que corre a velocidades increíbles.', 0, 3, 'Pokémon Legendario', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (60, 50, 255, 'azul', 'Su piel es tan fina que sus órganos internos pueden verse a través de ella. No puede soportar el aire seco.', 0, 1, 'Pokémon Renacuajo', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (61, 50, 120, 'azul', 'La espiral en su vientre se retuerce suavemente. No es bueno mirarlo fijamente, ya que puede causar somnolencia.', 0, 1, 'Pokémon Renacuajo', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (62, 50, 45, 'azul', 'Un experto en artes marciales. Puede nadar fácilmente incluso en aguas muy frías.', 0, 1, 'Pokémon Renacuajo', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (63, 50, 200, 'marrón', 'Duerme 18 horas al día. Si usa sus poderes psíquicos, su cerebro consume energía, lo que le hace tener más hambre.', 0, 3, 'Pokémon Psi', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (64, 50, 100, 'marrón', 'Emite ondas alfa que pueden causar dolores de cabeza. Solo usa el 10% de su capacidad cerebral.', 0, 3, 'Pokémon Psi', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (65, 50, 50, 'marrón', 'Su cerebro puede realizar cálculos complejos más rápido que una supercomputadora. Puede recordar todo lo que ha ocurrido desde su nacimiento.', 0, 3, 'Pokémon Psi', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (66, 50, 180, 'gris', 'Le encanta la fuerza bruta. Puede levantar a un adulto con facilidad, aunque es del tamaño de un niño.', 0, 3, 'Pokémon Superpoderoso', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (67, 50, 90, 'gris', 'Su cuerpo musculoso es tan fuerte que usa un cinturón de poder para controlar sus movimientos.', 0, 3, 'Pokémon Superpoderoso', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (68, 50, 45, 'gris', 'Tiene la fuerza para mover montañas con una sola mano. Sin embargo, su cerebro es pequeño, por lo que no es muy inteligente.', 0, 3, 'Pokémon Superpoderoso', 'generation-i', 'montaña', 0, 20, 0, 0, 0),
  (69, 50, 255, 'verde', 'Prefiere lugares cálidos y húmedos. Atrapa insectos con sus lianas para devorarlos.', 0, 1, 'Pokémon Flor', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (70, 50, 120, 'verde', 'Escupe un fluido corrosivo que puede disolver incluso hierro. Una vez que atrapa a su presa, la disuelve con su ácido.', 0, 1, 'Pokémon Matamoscas', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (71, 50, 45, 'verde', 'Vive en junglas densas. Atrae a sus presas con un dulce aroma y luego las devora enteras.', 0, 1, 'Pokémon Matamoscas', 'generation-i', 'bosque', 0, 20, 0, 0, 0),
  (72, 50, 190, 'azul', 'Vive en mares poco profundos. Sus tentáculos son muy venenosos, aunque su picadura no es mortal.', 0, 1, 'Pokémon Medusa', 'generation-i', 'mar', 0, 20, 0, 0, 0),
  (73, 50, 60, 'azul', 'Sus 80 tentáculos pueden estirarse y contraerse a voluntad. Envuelve a su presa y la debilita con veneno.', 0, 1, 'Pokémon Medusa', 'generation-i', 'mar', 0, 20, 0, 0, 0),
  (74, 50, 255, 'marrón', 'Vive en campos y montañas. La gente suele confundirlo con rocas y tropezar con él.', 0, 1, 'Pokémon Roca', 'generation-i', 'montaña', 0, 15, 0, 0, 0),
  (75, 50, 120, 'marrón', 'Rueda cuesta abajo para moverse. Si hay un obstáculo, lo hace explotar con su cuerpo para seguir avanzando.', 0, 1, 'Pokémon Roca', 'generation-i', 'montaña', 0, 15, 0, 0, 0),
  (76, 50, 45, 'marrón', 'Su cuerpo rocoso es extremadamente duro. Puede soportar explosiones de dinamita sin sufrir daños.', 0, 1, 'Pokémon Megaton', 'generation-i', 'montaña', 0, 15, 0, 0, 0),
  (77, 50, 190, 'amarillo', 'Muy veloz, puede correr a 150 km/h. Sus cascos son más duros que el diamante.', 0, 1, 'Pokémon Caballo Fuego', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (78, 50, 60, 'amarillo', 'Muy competitivo, perseguirá a cualquier cosa que se mueva rápido. Solo se calma cuando ve algo más rápido que él.', 0, 1, 'Pokémon Caballo Fuego', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (79, 50, 190, 'rosa', 'Increíblemente lento y torpe. Le toma 5 segundos sentir dolor cuando es atacado.', 0, 1, 'Pokémon Atontado', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (80, 50, 75, 'rosa', 'Un Shellder se ha adherido a su cola, convirtiéndolo en Slowbro. El Shellder se alimenta de los restos que deja Slowbro.', 0, 1, 'Pokémon Ermitaño', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (81, 50, 190, 'gris', 'Usa partes de su cuerpo para enviar ondas de radio. Puede flotar en el aire si se desmagnetiza.', 0, 8, 'Pokémon Imán', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (82, 50, 60, 'gris', 'Formado por tres Magnemite unidos. Puede emitir potentes ondas magnéticas que fríen los aparatos electrónicos cercanos.', 0, 8, 'Pokémon Imán', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (83, 50, 45, 'marrón', 'No puede vivir sin el puerro que lleva. Por eso lo defiende de los atacantes con todas sus fuerzas.', 0, 1, 'Pokémon Pato Salvaje', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (84, 50, 190, 'marrón', 'Un ave que no vuela bien. Cada cabeza come y piensa de forma independiente de la otra.', 0, 1, 'Pokémon Ave Gemela', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (85, 50, 45, 'marrón', 'Un ave extraña con tres cabezas. Puede correr a 60 km/h incluso en terrenos escarpados.', 0, 1, 'Pokémon Ave Triple', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (86, 50, 190, 'blanco', 'Le encanta congelarse en el agua helada. Su gruesa capa de grasa repele los ataques.', 0, 1, 'Pokémon León Marino', 'generation-i', 'mar', 0, 20, 0, 0, 0),
  (87, 50, 75, 'blanco', 'Almacena energía térmica en su cuerpo. Nada a 8 nudos incluso en aguas muy frías.', 0, 1, 'Pokémon León Marino', 'generation-i', 'mar', 0, 20, 0, 0, 0),
  (88, 50, 190, 'púrpura', 'Hecho de lodo endurecido. Huele tan mal que puede causar desmayos. El lodo se vuelve más tóxico al exponerse a rayos X.', 0, 1, 'Pokémon Lodo', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (89, 50, 75, 'púrpura', 'Su cuerpo está hecho de una masa tóxica que mata a las plantas y árboles al tocarlos. No deja de crecer mientras encuentre basura que comer.', 0, 1, 'Pokémon Lodo', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (90, 50, 190, 'púrpura', 'Se protege cerrando su concha, pero cuando ataca, dispara espinas desde ella.', 0, 1, 'Pokémon Bivalvo', 'generation-i', 'mar', 0, 20, 0, 0, 0),
  (91, 50, 60, 'púrpura', 'Su concha es más dura que el diamante. Dispara picos desde su concha para atacar.', 0, 1, 'Pokémon Bivalvo', 'generation-i', 'mar', 0, 20, 0, 0, 0),
  (92, 50, 190, 'púrpura', 'Hecho de gas. Puede atravesar paredes sólidas. Se dice que proviene de otra dimensión.', 0, 1, 'Pokémon Gas', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (93, 50, 90, 'púrpura', 'Se dice que puede robar la vida de sus víctimas lamiendo con su lengua gaseosa.', 0, 1, 'Pokémon Gas', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (94, 50, 45, 'púrpura', 'Se esconde en las sombras. Se dice que si Gengar está cerca, la temperatura baja 5 grados.', 0, 1, 'Pokémon Sombra', 'generation-i', 'ciudad', 0, 20, 0, 0, 0),
  (95, 50, 45, 'gris', 'Mientras excava, absorbe muchos objetos duros que se convierten en parte de su cuerpo. Esto lo hace más fuerte.', 0, 1, 'Pokémon Roca Serpiente', 'generation-i', 'cueva', 0, 25, 0, 0, 0),
  (96, 50, 190, 'amarillo', 'Si duermes cerca de él, comenzará a comer tus sueños a través de tu nariz.', 0, 1, 'Pokémon Hipnosis', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (97, 50, 75, 'amarillo', 'Lleva un péndulo que usa para poner a sus enemigos en trance profundo. Luego se alimenta de sus sueños.', 0, 1, 'Pokémon Hipnosis', 'generation-i', 'pradera', 0, 20, 0, 0, 0),
  (98, 50, 225, 'rojo', 'Sus pinzas son excelentes armas. A veces las pierde durante las peleas, pero vuelven a crecer.', 0, 1, 'Pokémon Cangrejo', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (99, 50, 60, 'rojo', 'Su pinza más grande puede tener más de 4.000 caballos de potencia. Sin embargo, su gran tamaño la hace difícil de manejar.', 0, 1, 'Pokémon Tenaza', 'generation-i', 'agua-orilla', 0, 20, 0, 0, 0),
  (100, 50, 190, 'rojo', 'Almacena energía eléctrica bajo mucha presión. Suele explotar al menor estímulo.', 0, 8, 'Pokémon Bola', 'generation-i', 'pradera', 0, 20, 0, 0, 0);

-- Abilities
INSERT INTO Ability (Id, Name, Description, IsHidden, IsSelected) VALUES
  (1, 'espesura', 'Potencia sus movimientos de tipo Planta cuando le quedan pocos PS.', 0, 1),
  (2, 'clorofila', 'Sube su Velocidad cuando hace sol.', 1, 0),
  (3, 'mar-llamas', 'Potencia sus movimientos de tipo Fuego cuando le quedan pocos PS.', 0, 1),
  (4, 'poder-solar', 'Aumenta el Ataque Especial pero reduce los PS cuando hace sol.', 1, 0),
  (5, 'torrente', 'Potencia sus movimientos de tipo Agua cuando le quedan pocos PS.', 0, 1),
  (6, 'cura-lluvia', 'Recupera PS cuando llueve.', 1, 0),
  (7, 'polvo-escudo', 'Bloquea los efectos secundarios de los ataques recibidos.', 0, 1),
  (8, 'fuga', 'Permite huir siempre de combates salvajes.', 0, 1),
  (9, 'mudar', 'Puede curar sus problemas de estado al cambiar de turno.', 1, 0),
  (10, 'ojos-compuestos', 'Aumenta la precisión de los movimientos.', 0, 1),
  (11, 'cromolente', 'Potencia los movimientos poco eficaces.', 1, 0),
  (12, 'enjambre', 'Potencia sus movimientos de tipo Bicho cuando le quedan pocos PS.', 0, 1),
  (13, 'francotirador', 'Potencia los golpes críticos.', 1, 0),
  (14, 'vista-lince', 'Evita que baje la precisión.', 0, 1),
  (15, 'tumbos', 'Sube la evasión si está confuso.', 0, 1),
  (16, 'sacapecho', 'Evita que baje la Defensa.', 1, 0),
  (17, 'agallas', 'Aumenta el Ataque si tiene un problema de estado.', 0, 1),
  (18, 'entusiasmo', 'Aumenta el Ataque pero reduce la precisión.', 0, 1),
  (19, 'intimidación', 'Baja el Ataque del rival al entrar en combate.', 0, 1),
  (20, 'nerviosismo', 'Impide que los rivales consuman bayas.', 1, 0),
  (21, 'electricidad-estática', 'Puede paralizar al contacto.', 0, 1),
  (22, 'pararrayos', 'Atrae los movimientos de tipo Eléctrico y sube el Ataque Especial.', 1, 0),
  (23, 'velo-arena', 'Aumenta la evasión durante una tormenta de arena.', 0, 1),
  (24, 'ímpetu-arena', 'Aumenta la velocidad durante una tormenta de arena.', 1, 0),
  (25, 'punto-tóxico', 'Puede envenenar al contacto.', 0, 1),
  (26, 'rivalidad', 'Aumenta el Ataque si el rival es del mismo género.', 0, 1),
  (27, 'potencia', 'Aumenta la potencia de los movimientos basados en poder físico.', 1, 0),
  (28, 'manto-níveo', 'Aumenta la evasión durante una granizada.', 1, 0),
  (29, 'gran-encanto', 'Puede causar atracción al contacto.', 0, 1),
  (30, 'amigo-guardia', 'Reduce el daño recibido por aliados.', 1, 0),
  (31, 'manto-espejo', 'Refleja los movimientos de estado.', 1, 0),
  (32, 'absorbe-sonido', 'Absorbe los movimientos de sonido, aumentando su Ataque Especial.', 1, 0),
  (33, 'insomnio', 'Evita que el Pokémon se duerma.', 0, 1),
  (34, 'cambio-táctico', 'Cambia las estadísticas del Pokémon al entrar en combate.', 1, 0),
  (35, 'clorofila', 'Aumenta la Velocidad cuando hace sol.', 0, 1),
  (36, 'hedor', 'Puede hacer retroceder al rival.', 0, 1),
  (37, 'efecto-espora', 'Puede causar parálisis, sueño o envenenamiento al contacto.', 1, 0),
  (38, 'piel-seca', 'Recupera PS con ataques de agua, pero recibe más daño de ataques de fuego.', 1, 0),
  (39, 'humedad', 'Evita movimientos explosivos.', 1, 0),
  (40, 'arena-movediza', 'Evita que el Pokémon sea levantado del suelo.', 0, 1),
  (41, 'recogida', 'Puede recoger objetos después de un combate.', 0, 1),
  (42, 'experto', 'Aumenta la potencia de movimientos poco potentes.', 1, 0),
  (43, 'nado-rápido', 'Duplica la Velocidad con lluvia.', 0, 1),
  (44, 'despiste', 'Evita que el rival use objetos.', 0, 1),
  (45, 'intrépido', 'Evita que el Pokémon retroceda.', 1, 0),
  (46, 'justiciero', 'Aumenta el Ataque cuando recibe un golpe crítico.', 0, 1),
  (47, 'sincronia', 'Transmite problemas de estado al rival.', 0, 1),
  (48, 'energía-pura', 'Evita que bajen las estadísticas del Pokémon.', 1, 0),
  (49, 'roca-sólida', 'Reduce el daño de ataques superefectivos.', 0, 1),
  (50, 'cabeza-roca', 'Evita daño de retroceso.', 1, 0),
  (51, 'corte-fuerte', 'Aumenta la potencia de movimientos cortantes.', 0, 1),
  (52, 'imán', 'Atrae Pokémon de tipo Acero.', 0, 1),
  (53, 'robustez', 'El Pokémon resiste con 1 PS un ataque que lo noquearía.', 1, 0),
  (54, 'madrugar', 'Aumenta la Velocidad si es el primer turno.', 0, 1),
  (55, 'hidratación', 'Cura problemas de estado cuando llueve.', 1, 0),
  (56, 'viscosidad', 'Puede bajar la Velocidad al contacto.', 0, 1),
  (57, 'caparazón', 'Evita golpes críticos.', 0, 1),
  (58, 'levitación', 'Inmune a ataques de tipo Tierra.', 0, 1),
  (59, 'cuerpo-maldito', 'Reduce PP del último movimiento usado por el rival.', 0, 1),
  (60, 'cacheo', 'Revela el objeto del rival al entrar en combate.', 1, 0);

-- EvolutionChain
INSERT INTO EvolutionChain (Id, BabyTriggerItem, SpeciesId) VALUES
  (1, NULL, 1),  -- Bulbasaur line
  (2, NULL, 4),  -- Charmander line
  (3, NULL, 7),  -- Squirtle line
  (4, NULL, 10), -- Caterpie line
  (5, NULL, 13), -- Weedle line
  (6, NULL, 16), -- Pidgey line
  (7, NULL, 19), -- Rattata line
  (8, NULL, 21), -- Spearow line
  (9, NULL, 23), -- Ekans line
  (10, NULL, 25), -- Pikachu line
  (11, NULL, 27), -- Sandshrew line
  (12, NULL, 29), -- Nidoran♀ line
  (13, NULL, 32), -- Nidoran♂ line
  (14, NULL, 35), -- Clefairy line
  (15, NULL, 37), -- Vulpix line
  (16, NULL, 39), -- Jigglypuff line
  (17, NULL, 41), -- Zubat line
  (18, NULL, 43), -- Oddish line
  (19, NULL, 46), -- Paras line
  (20, NULL, 48), -- Venonat line
  (21, NULL, 50), -- Diglett line
  (22, NULL, 52), -- Meowth line
  (23, NULL, 54), -- Psyduck line
  (24, NULL, 56), -- Mankey line
  (25, NULL, 58), -- Growlithe line
  (26, NULL, 60), -- Poliwag line
  (27, NULL, 63), -- Abra line
  (28, NULL, 66), -- Machop line
  (29, NULL, 69), -- Bellsprout line
  (30, NULL, 72), -- Tentacool line
  (31, NULL, 74), -- Geodude line
  (32, NULL, 77), -- Ponyta line
  (33, NULL, 79), -- Slowpoke line
  (34, NULL, 81), -- Magnemite line
  (35, NULL, 83), -- Farfetch'd line
  (36, NULL, 84), -- Doduo line
  (37, NULL, 86), -- Seel line
  (38, NULL, 88), -- Grimer line
  (39, NULL, 90), -- Shellder line
  (40, NULL, 92), -- Gastly line
  (41, NULL, 95), -- Onix line
  (42, NULL, 96), -- Drowzee line
  (43, NULL, 98), -- Krabby line
  (44, NULL, 100); -- Voltorb line

-- Variety (sin el campo Name)
INSERT INTO Variety (Id, IsDefault, SpeciesId) VALUES
  (1, 1, 1),  -- bulbasaur
  (2, 1, 2),  -- ivysaur
  (3, 1, 3),  -- venusaur
  (4, 0, 3),  -- venusaur-mega
  (5, 0, 3),  -- venusaur-gmax
  (6, 1, 4),  -- charmander
  (7, 1, 5),  -- charmeleon
  (8, 1, 6),  -- charizard
  (9, 0, 6),  -- charizard-mega-x
  (10, 0, 6), -- charizard-mega-y
  (11, 0, 6), -- charizard-gmax
  (12, 1, 7), -- squirtle
  (13, 1, 8), -- wartortle
  (14, 1, 9), -- blastoise
  (15, 0, 9), -- blastoise-mega
  (16, 0, 9), -- blastoise-gmax
  (17, 1, 10), -- caterpie
  (18, 1, 11), -- metapod
  (19, 1, 12), -- butterfree
  (20, 0, 12), -- butterfree-gmax
  (21, 1, 13), -- weedle
  (22, 1, 14), -- kakuna
  (23, 1, 15), -- beedrill
  (24, 0, 15), -- beedrill-mega
  (25, 1, 16), -- pidgey
  (26, 1, 17), -- pidgeotto
  (27, 1, 18), -- pidgeot
  (28, 0, 18), -- pidgeot-mega
  (29, 1, 19), -- rattata
  (30, 0, 19), -- rattata-alola
  (31, 1, 20), -- raticate
  (32, 0, 20), -- raticate-alola
  (33, 0, 20), -- raticate-totem-alola
  (34, 1, 21), -- spearow
  (35, 1, 22), -- fearow
  (36, 1, 23), -- ekans
  (37, 1, 24), -- arbok
  (38, 1, 25), -- pikachu
  (39, 0, 25), -- pikachu-gmax
  (40, 1, 26), -- raichu
  (41, 0, 26), -- raichu-alola
  (42, 1, 27), -- sandshrew
  (43, 0, 27), -- sandshrew-alola
  (44, 1, 28), -- sandslash
  (45, 0, 28), -- sandslash-alola
  (46, 1, 29), -- nidoran-f
  (47, 1, 30), -- nidorina
  (48, 1, 31), -- nidoqueen
  (49, 1, 32), -- nidoran-m
  (50, 1, 33), -- nidorino
  (51, 1, 34), -- nidoking
  (52, 1, 35), -- clefairy
  (53, 1, 36), -- clefable
  (54, 1, 37), -- vulpix
  (55, 0, 37), -- vulpix-alola
  (56, 1, 38), -- ninetales
  (57, 0, 38), -- ninetales-alola
  (58, 1, 39), -- jigglypuff
  (59, 1, 40), -- wigglytuff
  (60, 1, 41), -- zubat
  (61, 1, 42), -- golbat
  (62, 1, 43), -- oddish
  (63, 1, 44), -- gloom
  (64, 1, 45), -- vileplume
  (65, 1, 46), -- paras
  (66, 1, 47), -- parasect
  (67, 1, 48), -- venonat
  (68, 1, 49), -- venomoth
  (69, 1, 50), -- diglett
  (70, 0, 50), -- diglett-alola
  (71, 1, 51), -- dugtrio
  (72, 0, 51), -- dugtrio-alola
  (73, 1, 52), -- meowth
  (74, 0, 52), -- meowth-alola
  (75, 0, 52), -- meowth-galar
  (76, 0, 52), -- meowth-gmax
  (77, 1, 53), -- persian
  (78, 0, 53), -- persian-alola
  (79, 1, 54), -- psyduck
  (80, 1, 55), -- golduck
  (81, 1, 56), -- mankey
  (82, 1, 57), -- primeape
  (83, 1, 58), -- growlithe
  (84, 0, 58), -- growlithe-hisui
  (85, 1, 59), -- arcanine
  (86, 0, 59), -- arcanine-hisui
  (87, 1, 60), -- poliwag
  (88, 1, 61), -- poliwhirl
  (89, 1, 62), -- poliwrath
  (90, 1, 63), -- abra
  (91, 1, 64), -- kadabra
  (92, 1, 65), -- alakazam
  (93, 0, 65), -- alakazam-mega
  (94, 1, 66), -- machop
  (95, 1, 67), -- machoke
  (96, 1, 68), -- machamp
  (97, 0, 68), -- machamp-gmax
  (98, 1, 69), -- bellsprout
  (99, 1, 70), -- weepinbell
  (100, 1, 71), -- victreebel
  (101, 1, 72), -- tentacool
  (102, 1, 73), -- tentacruel
  (103, 1, 74), -- geodude
  (104, 0, 74), -- geodude-alola
  (105, 1, 75), -- graveler
  (106, 0, 75), -- graveler-alola
  (107, 1, 76), -- golem
  (108, 0, 76), -- golem-alola
  (109, 1, 77), -- ponyta
  (110, 0, 77), -- ponyta-galar
  (111, 1, 78), -- rapidash
  (112, 0, 78), -- rapidash-galar
  (113, 1, 79), -- slowpoke
  (114, 0, 79), -- slowpoke-galar
  (115, 1, 80), -- slowbro
  (116, 0, 80), -- slowbro-mega
  (117, 0, 80), -- slowbro-galar
  (118, 1, 81), -- magnemite
  (119, 1, 82), -- magneton
  (120, 1, 83), -- farfetchd
  (121, 0, 83), -- farfetchd-galar
  (122, 1, 84), -- doduo
  (123, 1, 85), -- dodrio
  (124, 1, 86), -- seel
  (125, 1, 87), -- dewgong
  (126, 1, 88), -- grimer
  (127, 0, 88), -- grimer-alola
  (128, 1, 89), -- muk
  (129, 0, 89), -- muk-alola
  (130, 1, 90), -- shellder
  (131, 1, 91), -- cloyster
  (132, 1, 92), -- gastly
  (133, 1, 93), -- haunter
  (134, 1, 94), -- gengar
  (135, 0, 94), -- gengar-mega
  (136, 0, 94), -- gengar-gmax
  (137, 1, 95), -- onix
  (138, 1, 96), -- drowzee
  (139, 1, 97), -- hypno
  (140, 1, 98), -- krabby
  (141, 1, 99), -- kingler
  (142, 0, 99), -- kingler-gmax
  (143, 1, 100); -- voltorb

-- EvolutionFamilyMember
INSERT INTO EvolutionFamilyMember (Id, PokemonEvolutionId, Gender, HeldItem, Item, KnownMove, KnownMoveType, Location, MinAffection, MinBeauty, MinHappiness, MinLevel, NeedsOverworldRain, PartySpecies, PartyType, RelativePhysicalStats, TimeOfDay, TradeSpecies, EvolutionTrigger, TurnUpsideDown, EvolutionChainId) VALUES
  -- Bulbasaur line
  (1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 1),
  (2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 32, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 1),
  (3, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1),
  
  -- Charmander line
  (4, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 2),
  (5, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 2),
  (6, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2),
  
  -- Squirtle line
  (7, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 3),
  (8, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 3),
  (9, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3),
  
  -- Caterpie line
  (10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 4),
  (11, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 4),
  (12, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4),
  
  -- Weedle line
  (13, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 5),
  (14, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 5),
  (15, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5),
  
  -- Pidgey line
  (16, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 18, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 6),
  (17, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 36, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 6),
  (18, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6),
  
  -- Rattata line
  (19, 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 7),
  (20, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 7),
  
  -- Spearow line
  (21, 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 8),
  (22, 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 8),
  
  -- Ekans line
  (23, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 9),
  (24, 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 9),
  
  -- Pikachu line
  (25, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10),
  (26, 26, NULL, NULL, 'piedra-trueno', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 10),
  
  -- Sandshrew line
  (27, 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 11),
  (28, 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 11),
  
  -- Nidoran♀ line
  (29, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 12),
  (30, 30, NULL, NULL, 'piedra-lunar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 12),
  (31, 31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 12),
  
  -- Nidoran♂ line
  (32, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 13),
  (33, 33, NULL, NULL, 'piedra-lunar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 13),
  (34, 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 13),
  
  -- Clefairy line
  (35, 35, NULL, NULL, 'piedra-lunar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 14),
  (36, 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 14),
  
  -- Vulpix line
  (37, 37, NULL, NULL, 'piedra-fuego', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 15),
  (38, 38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 15),
  
  -- Jigglypuff line
  (39, 39, NULL, NULL, 'piedra-lunar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 16),
  (40, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 16),
  
  -- Zubat line
  (41, 41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 22, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 17),
  (42, 42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 17),
  
  -- Oddish line
  (43, 43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 18),
  (44, 44, NULL, NULL, 'piedra-hoja', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 18),
  (45, 45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 18),
  
  -- Paras line
  (46, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 24, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 19),
  (47, 47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 19),
  
  -- Venonat line
  (48, 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 20),
  (49, 49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 20),
  
  -- Diglett line
  (50, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 21),
  (51, 51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 21),
  
  -- Meowth line
  (52, 52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 22),
  (53, 53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 22),
  
  -- Psyduck line
  (54, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 33, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 23),
  (55, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 23),
  
  -- Mankey line
  (56, 56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 24),
  (57, 57, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 24),
  
  -- Growlithe line
  (58, 58, NULL, NULL, 'piedra-fuego', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 25),
  (59, 59, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 25),
  
  -- Poliwag line
  (60, 60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 26),
  (61, 61, NULL, NULL, 'piedra-agua', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 26),
  (62, 62, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 26),
  
  -- Abra line
  (63, 63, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 16, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 27),
  (64, 64, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'trade', 0, 27),
  (65, 65, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 27),
  
  -- Machop line
  (66, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 28),
  (67, 67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'trade', 0, 28),
  (68, 68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 28),
  
  -- Bellsprout line
  (69, 69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 29),
  (70, 70, NULL, NULL, 'piedra-hoja', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 29),
  (71, 71, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 29),
  
  -- Tentacool line
  (72, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 30),
  (73, 73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 30),
  
  -- Geodude line
  (74, 74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 31),
  (75, 75, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'trade', 0, 31),
  (76, 76, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 31),
  
  -- Ponyta line
  (77, 77, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 32),
  (78, 78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 32),
  
  -- Slowpoke line
  (79, 79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 33),
  (80, 80, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 33),
  
  -- Magnemite line
  (81, 81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 34),
  (82, 82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 34),
  
  -- Farfetch'd line
  (83, 83, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 35),
  
  -- Doduo line
  (84, 84, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 31, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 36),
  (85, 85, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 36),
  
  -- Seel line
  (86, 86, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 34, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 37),
  (87, 87, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 37),
  
  -- Grimer line
  (88, 88, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 38, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 38),
  (89, 89, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 38),
  
  -- Shellder line
  (90, 90, NULL, NULL, 'piedra-agua', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'use-item', 0, 39),
  (91, 91, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 39),
  
  -- Gastly line
  (92, 92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 25, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 40),
  (93, 93, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'trade', 0, 40),
  (94, 94, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 40),
  
  -- Onix line
  (95, 95, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 41),
  
  -- Drowzee line
  (96, 96, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 26, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 42),
  (97, 97, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 42),
  
  -- Krabby line
  (98, 98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 28, 0, NULL, NULL, NULL, '', NULL, 'level-up', 0, 43),
  (99, 99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 43),
  
  -- Voltorb line
  (100, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 44);

-- Pokemon
INSERT INTO Pokemon (Id, Name, BaseExperience, Weight, Height, IsShiny, Gender, SpeciesId, VarietyId, EvolutionFamilyMemberId) VALUES
  (1, 'bulbasaur', 64, 69, 7, 0, 'male', 1, 1, 1),
  (2, 'ivysaur', 142, 130, 10, 0, 'male', 2, 2, 2),
  (3, 'venusaur', 263, 1000, 20, 0, 'male', 3, 3, 3),
  (4, 'charmander', 62, 85, 6, 0, 'male', 4, 6, 4),
  (5, 'charmeleon', 142, 190, 11, 0, 'male', 5, 7, 5),
  (6, 'charizard', 267, 905, 17, 0, 'male', 6, 8, 6),
  (7, 'squirtle', 63, 90, 5, 0, 'male', 7, 12, 7),
  (8, 'wartortle', 142, 225, 10, 0, 'male', 8, 13, 8),
  (9, 'blastoise', 265, 855, 16, 0, 'male', 9, 14, 9),
  (10, 'caterpie', 39, 29, 3, 0, 'male', 10, 17, 10),
  (11, 'metapod', 72, 99, 7, 0, 'male', 11, 18, 11),
  (12, 'butterfree', 198, 320, 11, 0, 'male', 12, 19, 12),
  (13, 'weedle', 39, 32, 3, 0, 'male', 13, 21, 13),
  (14, 'kakuna', 72, 100, 6, 0, 'male', 14, 22, 14),
  (15, 'beedrill', 178, 295, 10, 0, 'male', 15, 23, 15),
  (16, 'pidgey', 50, 18, 3, 0, 'male', 16, 25, 16),
  (17, 'pidgeotto', 122, 300, 11, 0, 'male', 17, 26, 17),
  (18, 'pidgeot', 216, 395, 15, 0, 'male', 18, 27, 18),
  (19, 'rattata', 51, 35, 3, 0, 'male', 19, 29, 19),
  (20, 'raticate', 145, 185, 7, 0, 'male', 20, 31, 20),
  (21, 'spearow', 52, 20, 3, 0, 'male', 21, 34, 21),
  (22, 'fearow', 155, 380, 12, 0, 'male', 22, 35, 22),
  (23, 'ekans', 58, 69, 20, 0, 'male', 23, 36, 23),
  (24, 'arbok', 157, 650, 35, 0, 'male', 24, 37, 24),
  (25, 'pikachu', 112, 60, 4, 0, 'male', 25, 38, 25),
  (26, 'raichu', 243, 300, 8, 0, 'male', 26, 40, 26),
  (27, 'sandshrew', 60, 120, 6, 0, 'male', 27, 42, 27),
  (28, 'sandslash', 158, 295, 10, 0, 'male', 28, 44, 28),
  (29, 'nidoran-f', 55, 70, 4, 0, 'female', 29, 46, 29),
  (30, 'nidorina', 128, 200, 8, 0, 'female', 30, 47, 30),
  (31, 'nidoqueen', 253, 600, 13, 0, 'female', 31, 48, 31),
  (32, 'nidoran-m', 55, 90, 5, 0, 'male', 32, 49, 32),
  (33, 'nidorino', 128, 195, 9, 0, 'male', 33, 50, 33),
  (34, 'nidoking', 253, 620, 14, 0, 'male', 34, 51, 34),
  (35, 'clefairy', 113, 75, 6, 0, 'female', 35, 52, 35),
  (36, 'clefable', 242, 400, 13, 0, 'female', 36, 53, 36),
  (37, 'vulpix', 60, 99, 6, 0, 'female', 37, 54, 37),
  (38, 'ninetales', 177, 199, 11, 0, 'female', 38, 56, 38),
  (39, 'jigglypuff', 95, 55, 5, 0, 'female', 39, 58, 39),
  (40, 'wigglytuff', 218, 120, 10, 0, 'female', 40, 59, 40),
  (41, 'zubat', 49, 75, 8, 0, 'male', 41, 60, 41),
  (42, 'golbat', 159, 550, 16, 0, 'male', 42, 61, 42),
  (43, 'oddish', 64, 54, 5, 0, 'male', 43, 62, 43),
  (44, 'gloom', 138, 86, 8, 0, 'male', 44, 63, 44),
  (45, 'vileplume', 245, 186, 12, 0, 'male', 45, 64, 45),
  (46, 'paras', 57, 54, 3, 0, 'male', 46, 65, 46),
  (47, 'parasect', 142, 295, 10, 0, 'male', 47, 66, 47),
  (48, 'venonat', 61, 300, 10, 0, 'male', 48, 67, 48),
  (49, 'venomoth', 158, 125, 15, 0, 'male', 49, 68, 49),
  (50, 'diglett', 53, 8, 2, 0, 'male', 50, 69, 50),
  (51, 'dugtrio', 149, 333, 7, 0, 'male', 51, 71, 51),
  (52, 'meowth', 58, 42, 4, 0, 'male', 52, 73, 52),
  (53, 'persian', 154, 320, 10, 0, 'male', 53, 77, 53),
  (54, 'psyduck', 64, 196, 8, 0, 'male', 54, 79, 54),
  (55, 'golduck', 175, 766, 17, 0, 'male', 55, 80, 55),
  (56, 'mankey', 61, 280, 5, 0, 'male', 56, 81, 56),
  (57, 'primeape', 159, 320, 10, 0, 'male', 57, 82, 57),
  (58, 'growlithe', 70, 190, 7, 0, 'male', 58, 83, 58),
  (59, 'arcanine', 194, 1550, 19, 0, 'male', 59, 85, 59),
  (60, 'poliwag', 60, 124, 6, 0, 'male', 60, 87, 60),
  (61, 'poliwhirl', 135, 200, 10, 0, 'male', 61, 88, 61),
  (62, 'poliwrath', 255, 540, 13, 0, 'male', 62, 89, 62),
  (63, 'abra', 62, 195, 9, 0, 'male', 63, 90, 63),
  (64, 'kadabra', 140, 565, 13, 0, 'male', 64, 91, 64),
  (65, 'alakazam', 250, 480, 15, 0, 'male', 65, 92, 65),
  (66, 'machop', 61, 195, 8, 0, 'male', 66, 94, 66),
  (67, 'machoke', 142, 705, 15, 0, 'male', 67, 95, 67),
  (68, 'machamp', 253, 1300, 16, 0, 'male', 68, 96, 68),
  (69, 'bellsprout', 60, 40, 7, 0, 'male', 69, 98, 69),
  (70, 'weepinbell', 137, 64, 10, 0, 'male', 70, 99, 70),
  (71, 'victreebel', 221, 155, 17, 0, 'male', 71, 100, 71),
  (72, 'tentacool', 67, 455, 9, 0, 'male', 72, 101, 72),
  (73, 'tentacruel', 180, 550, 16, 0, 'male', 73, 102, 73),
  (74, 'geodude', 60, 200, 4, 0, 'male', 74, 103, 74),
  (75, 'graveler', 137, 1050, 10, 0, 'male', 75, 105, 75),
  (76, 'golem', 223, 3000, 14, 0, 'male', 76, 107, 76),
  (77, 'ponyta', 82, 300, 10, 0, 'male', 77, 109, 77),
  (78, 'rapidash', 175, 950, 17, 0, 'male', 78, 111, 78),
  (79, 'slowpoke', 63, 360, 12, 0, 'male', 79, 113, 79),
  (80, 'slowbro', 172, 785, 16, 0, 'male', 80, 115, 80),
  (81, 'magnemite', 65, 60, 3, 0, 'unknown', 81, 118, 81),
  (82, 'magneton', 163, 600, 10, 0, 'unknown', 82, 119, 82),
  (83, 'farfetchd', 132, 150, 8, 0, 'male', 83, 120, 83),
  (84, 'doduo', 62, 392, 14, 0, 'male', 84, 122, 84),
  (85, 'dodrio', 165, 852, 18, 0, 'male', 85, 123, 85),
  (86, 'seel', 65, 900, 11, 0, 'male', 86, 124, 86),
  (87, 'dewgong', 166, 1200, 17, 0, 'male', 87, 125, 87),
  (88, 'grimer', 65, 300, 9, 0, 'male', 88, 126, 88),
  (89, 'muk', 175, 300, 12, 0, 'male', 89, 128, 89),
  (90, 'shellder', 61, 40, 3, 0, 'male', 90, 130, 90),
  (91, 'cloyster', 184, 1325, 15, 0, 'male', 91, 131, 91),
  (92, 'gastly', 62, 1, 13, 0, 'male', 92, 132, 92),
  (93, 'haunter', 142, 1, 16, 0, 'male', 93, 133, 93),
  (94, 'gengar', 250, 405, 15, 0, 'male', 94, 134, 94),
  (95, 'onix', 77, 2100, 88, 0, 'male', 95, 137, 95),
  (96, 'drowzee', 66, 324, 10, 0, 'male', 96, 138, 96),
  (97, 'hypno', 169, 756, 16, 0, 'male', 97, 139, 97),
  (98, 'krabby', 65, 65, 4, 0, 'male', 98, 140, 98),
  (99, 'kingler', 166, 600, 13, 0, 'male', 99, 141, 99),
  (100, 'voltorb', 66, 104, 5, 0, 'unknown', 100, 143, 100);

-- SpeciesAbility
INSERT INTO SpeciesAbility (SpeciesId, AbilityId) VALUES
  -- Bulbasaur
  (1, 1), -- Espesura (normal)
  (1, 2), -- Clorofila (oculta)

  -- Ivysaur
  (2, 1), -- Espesura (normal)
  (2, 2), -- Clorofila (oculta)

  -- Venusaur
  (3, 1), -- Espesura (normal)
  (3, 2), -- Clorofila (oculta)

  -- Charmander
  (4, 3), -- Mar Llamas (normal)
  (4, 4), -- Poder Solar (oculta)

  -- Charmeleon
  (5, 3), -- Mar Llamas (normal)
  (5, 4), -- Poder Solar (oculta)

  -- Charizard
  (6, 3), -- Mar Llamas (normal)
  (6, 4), -- Poder Solar (oculta)

  -- Squirtle
  (7, 5), -- Torrente (normal)
  (7, 6), -- Cura Lluvia (oculta)

  -- Wartortle
  (8, 5), -- Torrente (normal)
  (8, 6), -- Cura Lluvia (oculta)

  -- Blastoise
  (9, 5), -- Torrente (normal)
  (9, 6), -- Cura Lluvia (oculta)

  -- Caterpie
  (10, 7), -- Polvo Escudo (normal)
  (10, 9), -- Mudar (oculta)

  -- Metapod
  (11, 7), -- Polvo Escudo (normal)

  -- Butterfree
  (12, 10), -- Ojos Compuestos (normal)
  (12, 11), -- Cromolente (oculta)

  -- Weedle
  (13, 7), -- Polvo Escudo (normal)
  (13, 9), -- Mudar (oculta)

  -- Kakuna
  (14, 7), -- Polvo Escudo (normal)

  -- Beedrill
  (15, 12), -- Enjambre (normal)
  (15, 13), -- Francotirador (oculta)

  -- Pidgey
  (16, 14), -- Vista Lince (normal)
  (16, 15), -- Tumbos (normal)
  (16, 16), -- Sacapecho (oculta)

  -- Pidgeotto
  (17, 14), -- Vista Lince (normal)
  (17, 15), -- Tumbos (normal)
  (17, 16), -- Sacapecho (oculta)

  -- Pidgeot
  (18, 14), -- Vista Lince (normal)
  (18, 15), -- Tumbos (normal)
  (18, 16), -- Sacapecho (oculta)

  -- Rattata
  (19, 8), -- Fuga (normal)
  (19, 17), -- Agallas (normal)
  (19, 18), -- Entusiasmo (oculta)

  -- Raticate
  (20, 19), -- Intimidación (normal)
  (20, 8), -- Fuga (normal)
  (20, 20), -- Nerviosismo (oculta)

  -- Spearow
  (21, 14), -- Vista Lince (normal)
  (21, 13), -- Francotirador (oculta)

  -- Fearow
  (22, 14), -- Vista Lince (normal)
  (22, 13), -- Francotirador (oculta)

  -- Ekans
  (23, 19), -- Intimidación (normal)
  (23, 7), -- Polvo Escudo (normal)
  (23, 20), -- Nerviosismo (oculta)

  -- Arbok
  (24, 19), -- Intimidación (normal)
  (24, 7), -- Polvo Escudo (normal)
  (24, 20), -- Nerviosismo (oculta)

  -- Pikachu
  (25, 21), -- Electricidad Estática (normal)
  (25, 22), -- Pararrayos (oculta)

  -- Raichu
  (26, 21), -- Electricidad Estática (normal)
  (26, 22), -- Pararrayos (oculta)

  -- Sandshrew
  (27, 23), -- Velo Arena (normal)
  (27, 24), -- Ímpetu Arena (oculta)

  -- Sandslash
  (28, 23), -- Velo Arena (normal)
  (28, 24), -- Ímpetu Arena (oculta)

  -- Nidoran♀
  (29, 25), -- Punto Tóxico (normal)
  (29, 26), -- Rivalidad (normal)
  (29, 27), -- Potencia (oculta)

  -- Nidorina
  (30, 25), -- Punto Tóxico (normal)
  (30, 26), -- Rivalidad (normal)
  (30, 27), -- Potencia (oculta)

  -- Nidoqueen
  (31, 25), -- Punto Tóxico (normal)
  (31, 26), -- Rivalidad (normal)
  (31, 7), -- Polvo Escudo (oculta)

  -- Nidoran♂
  (32, 25), -- Punto Tóxico (normal)
  (32, 26), -- Rivalidad (normal)
  (32, 27), -- Potencia (oculta)

  -- Nidorino
  (33, 25), -- Punto Tóxico (normal)
  (33, 26), -- Rivalidad (normal)
  (33, 27), -- Potencia (oculta)

  -- Nidoking
  (34, 25), -- Punto Tóxico (normal)
  (34, 26), -- Rivalidad (normal)
  (34, 7), -- Polvo Escudo (oculta)

  -- Clefairy
  (35, 29), -- Gran Encanto (normal)
  (35, 30), -- Amigo Guardia (oculta)

  -- Clefable
  (36, 29), -- Gran Encanto (normal)
  (36, 30), -- Amigo Guardia (oculta)

  -- Vulpix
  (37, 19), -- Intimidación (normal)
  (37, 31), -- Manto Espejo (oculta)

  -- Ninetales
  (38, 19), -- Intimidación (normal)
  (38, 31), -- Manto Espejo (oculta)

  -- Jigglypuff
  (39, 29), -- Gran Encanto (normal)
  (39, 32), -- Absorbe Sonido (oculta)

  -- Wigglytuff
  (40, 29), -- Gran Encanto (normal)
  (40, 32), -- Absorbe Sonido (oculta)

  -- Zubat
  (41, 33), -- Insomnio (normal)
  (41, 34), -- Cambio Táctico (oculta)

  -- Golbat
  (42, 33), -- Insomnio (normal)
  (42, 34), -- Cambio Táctico (oculta)

  -- Oddish
  (43, 35), -- Clorofila (normal)
  (43, 8), -- Fuga (oculta)

  -- Gloom
  (44, 35), -- Clorofila (normal)
  (44, 36), -- Hedor (oculta)

  -- Vileplume
  (45, 35), -- Clorofila (normal)
  (45, 37), -- Efecto Espora (oculta)

  -- Paras
  (46, 37), -- Efecto Espora (normal)
  (46, 38), -- Piel Seca (oculta)

  -- Parasect
  (47, 37), -- Efecto Espora (normal)
  (47, 38), -- Piel Seca (oculta)

  -- Venonat
  (48, 10), -- Ojos Compuestos (normal)
  (48, 11), -- Cromolente (oculta)

  -- Venomoth
  (49, 7), -- Polvo Escudo (normal)
  (49, 11), -- Cromolente (oculta)

  -- Diglett
  (50, 40), -- Arena Movediza (normal)
  (50, 24), -- Ímpetu Arena (oculta)

  -- Dugtrio
  (51, 40), -- Arena Movediza (normal)
  (51, 24), -- Ímpetu Arena (oculta)

  -- Meowth
  (52, 41), -- Recogida (normal)
  (52, 42), -- Experto (oculta)

  -- Persian
  (53, 19), -- Intimidación (normal)
  (53, 42), -- Experto (oculta)

  -- Psyduck
  (54, 39), -- Humedad (normal)
  (54, 43), -- Nado Rápido (oculta)

  -- Golduck
  (55, 39), -- Humedad (normal)
  (55, 43), -- Nado Rápido (oculta)

  -- Mankey
  (56, 44), -- Despiste (normal)
  (56, 45), -- Intrépido (oculta)

  -- Primeape
  (57, 44), -- Despiste (normal)
  (57, 46), -- Justiciero (oculta)

  -- Growlithe
  (58, 19), -- Intimidación (normal)
  (58, 46), -- Justiciero (oculta)

  -- Arcanine
  (59, 19), -- Intimidación (normal)
  (59, 46), -- Justiciero (oculta)

  -- Poliwag
  (60, 11), -- Absorbe Agua (normal)
  (60, 43), -- Nado Rápido (oculta)

  -- Poliwhirl
  (61, 11), -- Absorbe Agua (normal)
  (61, 43), -- Nado Rápido (oculta)

  -- Poliwrath
  (62, 11), -- Absorbe Agua (normal)
  (62, 43), -- Nado Rápido (oculta)

  -- Abra
  (63, 47), -- Sincronia (normal)
  (63, 34), -- Cambio Táctico (oculta)

  -- Kadabra
  (64, 47), -- Sincronia (normal)
  (64, 34), -- Cambio Táctico (oculta)

  -- Alakazam
  (65, 47), -- Sincronia (normal)
  (65, 34), -- Cambio Táctico (oculta)

  -- Machop
  (66, 17), -- Agallas (normal)
  (66, 48), -- Energía Pura (oculta)

  -- Machoke
  (67, 17), -- Agallas (normal)
  (67, 48), -- Energía Pura (oculta)

  -- Machamp
  (68, 17), -- Agallas (normal)
  (68, 48), -- Energía Pura (oculta)

  -- Bellsprout
  (69, 35), -- Clorofila (normal)
  (69, 16), -- Sacapecho (oculta)

  -- Weepinbell
  (70, 35), -- Clorofila (normal)
  (70, 16), -- Sacapecho (oculta)

  -- Victreebel
  (71, 35), -- Clorofila (normal)
  (71, 16), -- Sacapecho (oculta)

  -- Tentacool
  (72, 39), -- Cuerpo Puro (normal)
  (72, 25), -- Punto Tóxico (oculta)

  -- Tentacruel
  (73, 39), -- Cuerpo Puro (normal)
  (73, 25), -- Punto Tóxico (oculta)

  -- Geodude
  (74, 49), -- Roca Sólida (normal)
  (74, 50), -- Cabeza Roca (oculta)

  -- Graveler
  (75, 49), -- Roca Sólida (normal)
  (75, 50), -- Cabeza Roca (oculta)

  -- Golem
  (76, 49), -- Roca Sólida (normal)
  (76, 50), -- Cabeza Roca (oculta)

  -- Ponyta
  (77, 8), -- Fuga (normal)
  (77, 19), -- Intimidación (oculta)

  -- Rapidash
  (78, 8), -- Fuga (normal)
  (78, 19), -- Intimidación (oculta)

  -- Slowpoke
  (79, 33), -- Insomnio (normal)
  (79, 48), -- Energía Pura (oculta)

  -- Slowbro
  (80, 33), -- Insomnio (normal)
  (80, 48), -- Energía Pura (oculta)

  -- Magnemite
  (81, 52), -- Imán (normal)
  (81, 53), -- Robustez (oculta)

  -- Magneton
  (82, 52), -- Imán (normal)
  (82, 53), -- Robustez (oculta)

  -- Farfetch'd
  (83, 14), -- Vista Lince (normal)
  (83, 34), -- Cambio Táctico (oculta)

  -- Doduo
  (84, 8), -- Fuga (normal)
  (84, 54), -- Madrugar (oculta)

  -- Dodrio
  (85, 8), -- Fuga (normal)
  (85, 54), -- Madrugar (oculta)

  -- Seel
  (86, 23), -- Velo Grueso (normal)
  (86, 55), -- Hidratación (oculta)

  -- Dewgong
  (87, 23), -- Velo Grueso (normal)
  (87, 55), -- Hidratación (oculta)

  -- Grimer
  (88, 36), -- Hedor (normal)
  (88, 56), -- Viscosidad (oculta)

  -- Muk
  (89, 36), -- Hedor (normal)
  (89, 56), -- Viscosidad (oculta)

  -- Shellder
  (90, 57), -- Caparazón (normal)
  (90, 53), -- Robustez (oculta)

  -- Cloyster
  (91, 57), -- Caparazón (normal)
  (91, 53), -- Robustez (oculta)

  -- Gastly
  (92, 58), -- Levitación (normal)

  -- Haunter
  (93, 58), -- Levitación (normal)

  -- Gengar
  (94, 59), -- Cuerpo Maldito (normal)

  -- Onix
  (95, 49), -- Roca Sólida (normal)
  (95, 53), -- Robustez (oculta)

  -- Drowzee
  (96, 33), -- Insomnio (normal)
  (96, 60), -- Cacheo (oculta)

  -- Hypno
  (97, 33), -- Insomnio (normal)
  (97, 60), -- Cacheo (oculta)

  -- Krabby
  (98, 51), -- Corte Fuerte (normal)
  (98, 57), -- Caparazón (oculta)

  -- Kingler
  (99, 51), -- Corte Fuerte (normal)
  (99, 57), -- Caparazón (oculta)

  -- Voltorb
  (100, 21), -- Electricidad Estática (normal)
  (100, 22); -- Pararrayos (oculta)
  
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
  (20, 5),
  (21, 4),
  (22, 4),
  (23, 5), (23, 14),
  (24, 5), (24, 14),
  (25, 5), (25, 6),
  (26, 5), (26, 6),
  (27, 5),
  (28, 5),
  (29, 1),
  (30, 1),
  (31, 1),
  (32, 1),
  (33, 1),
  (34, 1),
  (35, 6),
  (36, 6),
  (37, 5),
  (38, 5),
  (39, 6),
  (40, 6),
  (41, 4),
  (42, 4),
  (43, 7),
  (44, 7),
  (45, 7),
  (46, 3), (46, 7),
  (47, 3), (47, 7),
  (48, 3),
  (49, 3),
  (50, 5),
  (51, 5),
  (52, 5),
  (53, 5),
  (54, 2), (54, 5),
  (55, 2), (55, 5),
  (56, 5),
  (57, 5),
  (58, 5),
  (59, 5),
  (60, 2),
  (61, 2),
  (62, 2),
  (63, 8),
  (64, 8),
  (65, 8),
  (66, 8),
  (67, 8),
  (68, 8),
  (69, 7),
  (70, 7),
  (71, 7),
  (72, 9),
  (73, 9),
  (74, 10),
  (75, 10),
  (76, 10),
  (77, 5),
  (78, 5),
  (79, 1), (79, 2),
  (80, 1), (80, 2),
  (81, 10),
  (82, 10),
  (83, 4), (83, 5),
  (84, 4),
  (85, 4),
  (86, 2), (86, 5),
  (87, 2), (87, 5),
  (88, 11),
  (89, 11),
  (90, 2),
  (91, 2),
  (92, 11),
  (93, 11),
  (94, 11),
  (95, 10),
  (96, 8),
  (97, 8),
  (98, 2),
  (99, 2),
  (100, 10);

-- SpeciesType
INSERT INTO SpeciesType (Id, Slot, SpeciesId, TypeId) VALUES
  (1, 1, 1, 12), -- Bulbasaur: Planta
  (2, 2, 1, 4),  -- Bulbasaur: Veneno
  (3, 1, 2, 12), -- Ivysaur: Planta
  (4, 2, 2, 4),  -- Ivysaur: Veneno
  (5, 1, 3, 12), -- Venusaur: Planta
  (6, 2, 3, 4),  -- Venusaur: Veneno
  (7, 1, 4, 10), -- Charmander: Fuego
  (8, 1, 5, 10), -- Charmeleon: Fuego
  (9, 1, 6, 10), -- Charizard: Fuego
  (10, 2, 6, 3), -- Charizard: Volador
  (11, 1, 7, 11), -- Squirtle: Agua
  (12, 1, 8, 11), -- Wartortle: Agua
  (13, 1, 9, 11), -- Blastoise: Agua
  (14, 1, 10, 7), -- Caterpie: Bicho
  (15, 1, 11, 7), -- Metapod: Bicho
  (16, 1, 12, 7), -- Butterfree: Bicho
  (17, 2, 12, 3), -- Butterfree: Volador
  (18, 1, 13, 7), -- Weedle: Bicho
  (19, 2, 13, 4), -- Weedle: Veneno
  (20, 1, 14, 7), -- Kakuna: Bicho
  (21, 2, 14, 4), -- Kakuna: Veneno
  (22, 1, 15, 7), -- Beedrill: Bicho
  (23, 2, 15, 4), -- Beedrill: Veneno
  (24, 1, 16, 1), -- Pidgey: Normal
  (25, 2, 16, 3), -- Pidgey: Volador
  (26, 1, 17, 1), -- Pidgeotto: Normal
  (27, 2, 17, 3), -- Pidgeotto: Volador
  (28, 1, 18, 1), -- Pidgeot: Normal
  (29, 2, 18, 3), -- Pidgeot: Volador
  (30, 1, 19, 1), -- Rattata: Normal
  (31, 1, 20, 1), -- Raticate: Normal
  (32, 1, 21, 1), -- Spearow: Normal
  (33, 2, 21, 3), -- Spearow: Volador
  (34, 1, 22, 1), -- Fearow: Normal
  (35, 2, 22, 3), -- Fearow: Volador
  (36, 1, 23, 4), -- Ekans: Veneno
  (37, 1, 24, 4), -- Arbok: Veneno
  (38, 1, 25, 13), -- Pikachu: Eléctrico
  (39, 1, 26, 13), -- Raichu: Eléctrico
  (40, 1, 27, 5), -- Sandshrew: Tierra
  (41, 1, 28, 5), -- Sandslash: Tierra
  (42, 1, 29, 4), -- Nidoran♀: Veneno
  (43, 1, 30, 4), -- Nidorina: Veneno
  (44, 1, 31, 4), -- Nidoqueen: Veneno
  (45, 2, 31, 5), -- Nidoqueen: Tierra
  (46, 1, 32, 4), -- Nidoran♂: Veneno
  (47, 1, 33, 4), -- Nidorino: Veneno
  (48, 1, 34, 4), -- Nidoking: Veneno
  (49, 2, 34, 5), -- Nidoking: Tierra
  (50, 1, 35, 18), -- Clefairy: Hada
  (51, 1, 36, 18), -- Clefable: Hada
  (52, 1, 37, 10), -- Vulpix: Fuego
  (53, 1, 38, 10), -- Ninetales: Fuego
  (54, 1, 39, 1), -- Jigglypuff: Normal
  (55, 2, 39, 18), -- Jigglypuff: Hada
  (56, 1, 40, 1), -- Wigglytuff: Normal
  (57, 2, 40, 18), -- Wigglytuff: Hada
  (58, 1, 41, 4), -- Zubat: Veneno
  (59, 2, 41, 3), -- Zubat: Volador
  (60, 1, 42, 4), -- Golbat: Veneno
  (61, 2, 42, 3), -- Golbat: Volador
  (62, 1, 43, 12), -- Oddish: Planta
  (63, 2, 43, 4), -- Oddish: Veneno
  (64, 1, 44, 12), -- Gloom: Planta
  (65, 2, 44, 4), -- Gloom: Veneno
  (66, 1, 45, 12), -- Vileplume: Planta
  (67, 2, 45, 4), -- Vileplume: Veneno
  (68, 1, 46, 7), -- Paras: Bicho
  (69, 2, 46, 12), -- Paras: Planta
  (70, 1, 47, 7), -- Parasect: Bicho
  (71, 2, 47, 12), -- Parasect: Planta
  (72, 1, 48, 7), -- Venonat: Bicho
  (73, 2, 48, 4), -- Venonat: Veneno
  (74, 1, 49, 7), -- Venomoth: Bicho
  (75, 2, 49, 4), -- Venomoth: Veneno
  (76, 1, 50, 5), -- Diglett: Tierra
  (77, 1, 51, 5), -- Dugtrio: Tierra
  (78, 1, 52, 1), -- Meowth: Normal
  (79, 1, 53, 1), -- Persian: Normal
  (80, 1, 54, 11), -- Psyduck: Agua
  (81, 1, 55, 11), -- Golduck: Agua
  (82, 1, 56, 2), -- Mankey: Lucha
  (83, 1, 57, 2), -- Primeape: Lucha
  (84, 1, 58, 10), -- Growlithe: Fuego
  (85, 1, 59, 10), -- Arcanine: Fuego
  (86, 1, 60, 11), -- Poliwag: Agua
  (87, 1, 61, 11), -- Poliwhirl: Agua
  (88, 1, 62, 11), -- Poliwrath: Agua
  (89, 2, 62, 2), -- Poliwrath: Lucha
  (90, 1, 63, 14), -- Abra: Psíquico
  (91, 1, 64, 14), -- Kadabra: Psíquico
  (92, 1, 65, 14), -- Alakazam: Psíquico
  (93, 1, 66, 2), -- Machop: Lucha
  (94, 1, 67, 2), -- Machoke: Lucha
  (95, 1, 68, 2), -- Machamp: Lucha
  (96, 1, 69, 12), -- Bellsprout: Planta
  (97, 2, 69, 4), -- Bellsprout: Veneno
  (98, 1, 70, 12), -- Weepinbell: Planta
  (99, 2, 70, 4), -- Weepinbell: Veneno
  (100, 1, 71, 12), -- Victreebel: Planta
  (101, 2, 71, 4), -- Victreebel: Veneno
  (102, 1, 72, 11), -- Tentacool: Agua
  (103, 2, 72, 4), -- Tentacool: Veneno
  (104, 1, 73, 11), -- Tentacruel: Agua
  (105, 2, 73, 4), -- Tentacruel: Veneno
  (106, 1, 74, 6), -- Geodude: Roca
  (107, 2, 74, 5), -- Geodude: Tierra
  (108, 1, 75, 6), -- Graveler: Roca
  (109, 2, 75, 5), -- Graveler: Tierra
  (110, 1, 76, 6), -- Golem: Roca
  (111, 2, 76, 5), -- Golem: Tierra
  (112, 1, 77, 10), -- Ponyta: Fuego
  (113, 1, 78, 10), -- Rapidash: Fuego
  (114, 1, 79, 11), -- Slowpoke: Agua
  (115, 2, 79, 14), -- Slowpoke: Psíquico
  (116, 1, 80, 11), -- Slowbro: Agua
  (117, 2, 80, 14), -- Slowbro: Psíquico
  (118, 1, 81, 13), -- Magnemite: Eléctrico
  (119, 2, 81, 9), -- Magnemite: Acero
  (120, 1, 82, 13), -- Magneton: Eléctrico
  (121, 2, 82, 9), -- Magneton: Acero
  (122, 1, 83, 1), -- Farfetch'd: Normal
  (123, 2, 83, 3), -- Farfetch'd: Volador
  (124, 1, 84, 1), -- Doduo: Normal
  (125, 2, 84, 3), -- Doduo: Volador
  (126, 1, 85, 1), -- Dodrio: Normal
  (127, 2, 85, 3), -- Dodrio: Volador
  (128, 1, 86, 11), -- Seel: Agua
  (129, 1, 87, 11), -- Dewgong: Agua
  (130, 2, 87, 15), -- Dewgong: Hielo
  (131, 1, 88, 4), -- Grimer: Veneno
  (132, 1, 89, 4), -- Muk: Veneno
  (133, 1, 90, 11), -- Shellder: Agua
  (134, 1, 91, 11), -- Cloyster: Agua
  (135, 2, 91, 15), -- Cloyster: Hielo
  (136, 1, 92, 8), -- Gastly: Fantasma
  (137, 2, 92, 4), -- Gastly: Veneno
  (138, 1, 93, 8), -- Haunter: Fantasma
  (139, 2, 93, 4), -- Haunter: Veneno
  (140, 1, 94, 8), -- Gengar: Fantasma
  (141, 2, 94, 4), -- Gengar: Veneno
  (142, 1, 95, 6), -- Onix: Roca
  (143, 2, 95, 5), -- Onix: Tierra
  (144, 1, 96, 14), -- Drowzee: Psíquico
  (145, 1, 97, 14), -- Hypno: Psíquico
  (146, 1, 98, 11), -- Krabby: Agua
  (147, 1, 99, 11), -- Kingler: Agua
  (148, 1, 100, 13); -- Voltorb: Eléctrico

-- DamageRelation
INSERT INTO DamageRelation (SpeciesId, TypeId, RelationType) VALUES
  -- Bulbasaur, Ivysaur, Venusaur (Planta/Veneno)
  (1, 10, 2.0), (1, 3, 2.0), (1, 14, 2.0), (1, 15, 2.0), -- Debilidades
  (1, 11, 0.5), (1, 12, 0.5), (1, 2, 0.5), (1, 4, 0.5), -- Resistencias
  (2, 10, 2.0), (2, 3, 2.0), (2, 14, 2.0), (2, 15, 2.0),
  (2, 11, 0.5), (2, 12, 0.5), (2, 2, 0.5), (2, 4, 0.5),
  (3, 10, 2.0), (3, 3, 2.0), (3, 14, 2.0), (3, 15, 2.0),
  (3, 11, 0.5), (3, 12, 0.5), (3, 2, 0.5), (3, 4, 0.5),
  
  -- Charmander, Charmeleon (Fuego)
  (4, 11, 2.0), (4, 5, 2.0), (4, 6, 2.0),
  (4, 10, 0.5), (4, 12, 0.5), (4, 7, 0.5), (4, 9, 0.5), (4, 18, 0.5),
  (5, 11, 2.0), (5, 5, 2.0), (5, 6, 2.0),
  (5, 10, 0.5), (5, 12, 0.5), (5, 7, 0.5), (5, 9, 0.5), (5, 18, 0.5),
  
  -- Charizard (Fuego/Volador)
  (6, 11, 2.0), (6, 13, 2.0), (6, 6, 4.0),
  (6, 10, 0.5), (6, 2, 0.5), (6, 7, 0.25), (6, 12, 0.25), (6, 18, 0.5),
  
  -- Squirtle, Wartortle, Blastoise (Agua)
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
  (10, 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/10.ogg', 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/10.ogg', 10);

-- Sprites
INSERT INTO Sprite (Id, Name, Icon, BackMale, BackFemale, BackShiny, BackShinyFemale, FrontMale, FrontFemale, FrontShiny, FrontShinyFemale, SpeciesId) VALUES
  (1, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/1.png', '', 1),
  (2, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/1.png', 1),
  (3, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/1.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/1.gif', 1),
  (4, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/2.png', '', 2),
  (5, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/2.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/2.png', 2),
  (6, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/2.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/2.gif', 2),
  (7, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/3.png', '', 3),
  (8, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/3.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/3.png', 3),
  (9, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/3.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/3.gif', 3),
  (10, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/4.png', '', 4),
  (11, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/4.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/4.png', 4),
  (12, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/4.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/4.gif', 4),
  (13, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/5.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/5.png', '', 5),
  (14, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/5.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/5.png', 5),
  (15, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/5.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/5.gif', 5),
  (16, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/6.png', '', 6),
  (17, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/6.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/6.png', 6),
  (18, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/6.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/6.gif', 6),
  (19, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/7.png', '', 7),
  (20, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/7.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/7.png', 7),
  (21, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/7.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/7.gif', 7),
  (22, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/8.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/8.png', '', 8),
  (23, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/8.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/8.png', 8),
  (24, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/8.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/8.gif', 8),
  (25, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/9.png', '', 9),
  (26, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/9.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/9.png', 9),
  (27, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/9.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/9.gif', 9),
  (28, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/10.png', '', 10),
  (29, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/10.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/10.png', 10),
  (30, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/10.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/10.gif', 10),
  (31, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/11.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/11.png', '', 11),
  (32, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/11.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/11.png', 11),
  (33, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/11.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/11.gif', 11),
  (34, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/12.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/12.png', '', 12),
  (35, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/12.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/12.png', 12),
  (36, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/12.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/12.gif', 12),
  (37, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/13.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/13.png', '', 13),
  (38, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/13.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/13.png', 13),
  (39, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/13.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/13.gif', 13),
  (40, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/14.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/14.png', '', 14),
  (41, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/14.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/14.png', 14),
  (42, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/14.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/14.gif', 14),
  (43, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/15.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/15.png', '', 15),
  (44, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/15.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/15.png', 15),
  (45, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/15.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/15.gif', 15),
  (46, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/16.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/16.png', '', 16),
  (47, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/16.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/16.png', 16),
  (48, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/16.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/16.gif', 16),
  (49, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/17.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/17.png', '', 17),
  (50, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/17.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/17.png', 17),
  (51, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/17.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/17.gif', 17),
  (52, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/18.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/18.png', '', 18),
  (53, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/18.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/18.png', 18),
  (54, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/18.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/18.gif', 18),
  (55, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/19.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/19.png', '', 19),
  (56, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/19.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/19.png', 19),
  (57, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/19.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/19.gif', 19),
  (58, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/20.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/20.png', '', 20),
  (59, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/20.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/20.png', 20),
  (60, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/20.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/20.gif', 20),
  (61, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/21.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/21.png', '', 21),
  (62, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/21.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/21.png', 21),
  (63, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/21.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/21.gif', 21),
  (64, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/22.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/22.png', '', 22),
  (65, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/22.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/22.png', 22),
  (66, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/22.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/22.gif', 22),
  (67, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/23.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/23.png', '', 23),
  (68, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/23.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/23.png', 23),
  (69, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/23.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/23.gif', 23),
  (70, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/24.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/24.png', '', 24),
  (71, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/24.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/24.png', 24),
  (72, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/24.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/24.gif', 24),
  (73, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/25.png', '', 25),
  (74, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/25.png', 25),
  (75, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/25.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/25.gif', 25),
  (76, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/26.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/26.png', '', 26),
  (77, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/26.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/26.png', 26),
  (78, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/26.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/26.gif', 26),
  (79, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/27.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/27.png', '', 27),
  (80, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/27.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/27.png', 27),
  (81, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/27.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/27.gif', 27),
  (82, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/28.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/28.png', '', 28),
  (83, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/28.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/28.png', 28),
  (84, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/28.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/28.gif', 28),
  (85, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/29.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/29.png', '', 29),
  (86, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/29.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/29.png', 29),
  (87, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/29.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/29.gif', 29),
  (88, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/30.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/30.png', '', 30),
  (89, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/30.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/30.png', 30),
  (90, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/30.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/30.gif', 30),
  (91, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/31.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/31.png', '', 31),
  (92, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/31.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/31.png', 31),
  (93, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/31.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/31.gif', 31),
  (94, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/32.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/32.png', '', 32),
  (95, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/32.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/32.png', 32),
  (96, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/32.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/32.gif', 32),
  (97, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/33.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/33.png', '', 33),
  (98, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/33.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/33.png', 33),
  (99, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/33.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/33.gif', 33),
  (100, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/34.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/34.png', '', 34),
  (101, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/34.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/34.png', 34),
  (102, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/34.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/34.gif', 34),
  (103, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/35.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/35.png', '', 35),
  (104, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/35.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/35.png', 35),
  (105, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/35.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/35.gif', 35),
  (106, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/36.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/36.png', '', 36),
  (107, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/36.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/36.png', 36),
  (108, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/36.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/36.gif', 36),
  (109, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/37.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/37.png', '', 37),
  (110, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/37.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/37.png', 37),
  (111, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/37.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/37.gif', 37),
  (112, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/38.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/38.png', '', 38),
  (113, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/38.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/38.png', 38),
  (114, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/38.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/38.gif', 38),
  (115, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/39.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/39.png', '', 39),
  (116, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/39.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/39.png', 39),
  (117, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/39.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/39.gif', 39),
  (118, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/40.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/40.png', '', 40),
  (119, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/40.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/40.png', 40),
  (120, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/40.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/40.gif', 40),
  (121, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/41.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/41.png', '', 41),
  (122, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/41.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/41.png', 41),
  (123, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/41.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/41.gif', 41),
  (124, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/42.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/42.png', '', 42),
  (125, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/42.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/42.png', 42),
  (126, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/42.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/42.gif', 42),
  (127, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/43.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/43.png', '', 43),
  (128, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/43.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/43.png', 43),
  (129, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/43.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/43.gif', 43),
  (130, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/44.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/44.png', '', 44),
  (131, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/44.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/44.png', 44),
  (132, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/44.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/44.gif', 44),
  (133, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/45.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/45.png', '', 45),
  (134, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/45.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/45.png', 45),
  (135, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/45.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/45.gif', 45),
  (136, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/46.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/46.png', '', 46),
  (137, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/46.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/46.png', 46),
  (138, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/46.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/46.gif', 46),
  (139, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/47.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/47.png', '', 47),
  (140, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/47.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/47.png', 47),
  (141, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/47.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/47.gif', 47),
  (142, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/48.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/48.png', '', 48),
  (143, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/48.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/48.png', 48),
  (144, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/48.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/48.gif', 48),
  (145, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/49.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/49.png', '', 49),
  (146, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/49.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/49.png', 49),
  (147, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/49.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/49.gif', 49),
  (148, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/50.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/50.png', '', 50),
  (149, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/50.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/50.png', 50),
  (150, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/50.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/50.gif', 50),
  (151, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/51.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/51.png', '', 51),
  (152, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/51.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/51.png', 51),
  (153, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/51.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/51.gif', 51),
  (154, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/52.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/52.png', '', 52),
  (155, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/52.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/52.png', 52),
  (156, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/52.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/52.gif', 52),
  (157, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/53.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/53.png', '', 53),
  (158, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/53.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/53.png', 53),
  (159, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/53.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/53.gif', 53),
  (160, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/54.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/54.png', '', 54),
  (161, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/54.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/54.png', 54),
  (162, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/54.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/54.gif', 54),
  (163, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/55.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/55.png', '', 55),
  (164, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/55.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/55.png', 55),
  (165, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/55.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/55.gif', 55),
  (166, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/56.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/56.png', '', 56),
  (167, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/56.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/56.png', 56),
  (168, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/56.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/56.gif', 56),
  (169, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/57.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/57.png', '', 57),
  (170, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/57.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/57.png', 57),
  (171, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/57.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/57.gif', 57),
  (172, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/58.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/58.png', '', 58),
  (173, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/58.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/58.png', 58),
  (174, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/58.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/58.gif', 58),
  (175, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/59.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/59.png', '', 59),
  (176, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/59.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/59.png', 59),
  (177, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/59.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/59.gif', 59),
  (178, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/60.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/60.png', '', 60),
  (179, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/60.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/60.png', 60),
  (180, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/60.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/60.gif', 60),
  (181, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/61.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/61.png', '', 61),
  (182, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/61.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/61.png', 61),
  (183, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/61.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/61.gif', 61),
  (184, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/62.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/62.png', '', 62),
  (185, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/62.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/62.png', 62),
  (186, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/62.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/62.gif', 62),
  (187, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/63.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/63.png', '', 63),
  (188, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/63.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/63.png', 63),
  (189, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/63.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/63.gif', 63),
  (190, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/64.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/64.png', '', 64),
  (191, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/64.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/64.png', 64),
  (192, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/64.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/64.gif', 64),
  (193, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/65.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/65.png', '', 65),
  (194, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/65.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/65.png', 65),
  (195, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/65.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/65.gif', 65),
  (196, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/66.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/66.png', '', 66),
  (197, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/66.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/66.png', 66),
  (198, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/66.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/66.gif', 66),
  (199, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/67.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/67.png', '', 67),
  (200, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/67.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/67.png', 67),
  (201, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/67.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/67.gif', 67),
  (202, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/68.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/68.png', '', 68),
  (203, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/68.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/68.png', 68),
  (204, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/68.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/68.gif', 68),
  (205, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/69.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/69.png', '', 69),
  (206, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/69.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/69.png', 69),
  (207, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/69.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/69.gif', 69),
  (208, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/70.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/70.png', '', 70),
  (209, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/70.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/70.png', 70),
  (210, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/70.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/70.gif', 70),
  (211, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/71.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/71.png', '', 71),
  (212, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/71.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/71.png', 71),
  (213, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/71.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/71.gif', 71),
  (214, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/72.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/72.png', '', 72),
  (215, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/72.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/72.png', 72),
  (216, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/72.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/72.gif', 72),
  (217, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/73.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/73.png', '', 73),
  (218, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/73.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/73.png', 73),
  (219, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/73.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/73.gif', 73),
  (220, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/74.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/74.png', '', 74),
  (221, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/74.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/74.png', 74),
  (222, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/74.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/74.gif', 74),
  (223, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/75.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/75.png', '', 75),
  (224, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/75.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/75.png', 75),
  (225, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/75.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/75.gif', 75),
  (226, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/76.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/76.png', '', 76),
  (227, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/76.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/76.png', 76),
  (228, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/76.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/76.gif', 76),
  (229, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/77.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/77.png', '', 77),
  (230, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/77.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/77.png', 77),
  (231, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/77.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/77.gif', 77),
  (232, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/78.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/78.png', '', 78),
  (233, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/78.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/78.png', 78),
  (234, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/78.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/78.gif', 78),
  (235, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/79.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/79.png', '', 79),
  (236, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/79.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/79.png', 79),
  (237, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/79.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/79.gif', 79),
  (238, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/80.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/80.png', '', 80),
  (239, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/80.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/80.png', 80),
  (240, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/80.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/80.gif', 80),
  (241, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/81.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/81.png', '', 81),
  (242, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/81.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/81.png', 81),
  (243, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/81.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/81.gif', 81),
  (244, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/82.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/82.png', '', 82),
  (245, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/82.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/82.png', 82),
  (246, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/82.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/82.gif', 82),
  (247, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/83.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/83.png', '', 83),
  (248, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/83.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/83.png', 83),
  (249, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/83.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/83.gif', 83),
  (250, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/84.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/84.png', '', 84),
  (251, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/84.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/84.png', 84),
  (252, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/84.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/84.gif', 84),
  (253, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/85.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/85.png', '', 85),
  (254, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/85.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/85.png', 85),
  (255, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/85.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/85.gif', 85),
  (256, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/86.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/86.png', '', 86),
  (257, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/86.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/86.png', 86),
  (258, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/86.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/86.gif', 86),
  (259, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/87.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/87.png', '', 87),
  (260, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/87.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/87.png', 87),
  (261, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/87.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/87.gif', 87),
  (262, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/88.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/88.png', '', 88),
  (263, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/88.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/88.png', 88),
  (264, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/88.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/88.gif', 88),
  (265, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/89.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/89.png', '', 89),
  (266, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/89.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/89.png', 89),
  (267, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/89.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/89.gif', 89),
  (268, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/90.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/90.png', '', 90),
  (269, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/90.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/90.png', 90),
  (270, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/90.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/90.gif', 90),
  (271, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/91.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/91.png', '', 91),
  (272, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/91.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/91.png', 91),
  (273, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/91.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/91.gif', 91),
  (274, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/92.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/92.png', '', 92),
  (275, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/92.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/92.png', 92),
  (276, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/92.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/92.gif', 92),
  (277, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/93.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/93.png', '', 93),
  (278, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/93.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/93.png', 93),
  (279, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/93.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/93.gif', 93),
  (280, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/94.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/94.png', '', 94),
  (281, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/94.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/94.png', 94),
  (282, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/94.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/94.gif', 94),
  (283, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/95.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/95.png', '', 95),
  (284, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/95.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/95.png', 95),
  (285, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/95.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/95.gif', 95),
  (286, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/96.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/96.png', '', 96),
  (287, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/96.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/96.png', 96),
  (288, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/96.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/96.gif', 96),
  (289, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/97.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/97.png', '', 97),
  (290, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/97.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/97.png', 97),
  (291, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/97.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/97.gif', 97),
  (292, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/98.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/98.png', '', 98),
  (293, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/98.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/98.png', 98),
  (294, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/98.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/98.gif', 98),
  (295, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/99.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/99.png', '', 99),
  (296, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/99.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/99.png', 99),
  (297, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/99.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/99.gif', 99),
  (298, 'artwork_oficial', 0, '', '', '', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/100.png', '', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/100.png', '', 100),
  (299, 'black_white', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/100.png', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/100.png', 100),
  (300, 'black_white_animated', 0, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/female/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/back/shiny/female/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/female/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/100.gif', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/shiny/female/100.gif', 100);

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
  (12, 60, 0, 2, 6);

-- Move
INSERT INTO Move (Id, Name, Accuracy, DamageClass, EffectChance, EffectText, CritRate, Drain, FlinchChance, Healing, MaxHits, MaxTurns, MinHits, MinTurns, StatChance, Power, Pp, Priority, Target, TypeId, PokemonId) VALUES
  -- Bulbasaur
  (1, 'Placaje', 100, 'Físico', NULL, 'Causa daño sin efectos adicionales.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 40, 35, 0, 'pokemon-seleccionado', 1, 1),
  (2, 'Gruñido', 100, 'Estado', NULL, 'Reduce el Ataque del objetivo en un nivel.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'todos-oponentes', 1, 1),
  (3, 'Drenadoras', 90, 'Estado', NULL, 'Siembra semillas en el objetivo, robándole PS en cada turno.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 10, 0, 'pokemon-seleccionado', 12, 1),
  (4, 'Látigo Cepa', 100, 'Físico', NULL, 'Causa daño sin efectos adicionales.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 45, 25, 0, 'pokemon-seleccionado', 12, 1),
  (10, 'Látigo', 100, 'Estado', NULL, 'Reduce la Defensa del objetivo en un nivel.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 30, 0, 'pokemon-seleccionado', 1, 10),
  (11, 'Burbuja', 100, 'Especial', 10, 'Puede reducir la Velocidad del objetivo.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 10, 40, 30, 0, 'pokemon-seleccionado', 11, 7),
  (12, 'Refugio', NULL, 'Estado', NULL, 'Aumenta la Defensa del usuario.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 40, 0, 'usuario', 11, 7),
  (14, 'Disparo Demora', 95, 'Físico', 100, 'Reduce la Velocidad del objetivo.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 100, 55, 15, 0, 'pokemon-seleccionado', 7, 13),
  (16, 'Disparo Demora', 95, 'Físico', 100, 'Reduce la Velocidad del objetivo.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 100, 55, 15, 0, 'pokemon-seleccionado', 7, 10),
  (18, 'Ataque Arena', 100, 'Estado', NULL, 'Reduce la Precisión del objetivo.', 0, 0, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 15, 0, 'pokemon-seleccionado', 5, 27);

-- StatChange
INSERT INTO StatChange (Id, Change, StatId, MoveId) VALUES
  (1, -1, 2, 2),  -- Gruñido reduce Ataque
  (2, -1, 3, 10), -- Látigo reduce Defensa
  (3, -1, 6, 11), -- Burbuja puede reducir Velocidad
  (4, 1, 3, 12),  -- Refugio aumenta Defensa
  (5, -1, 6, 14), -- Disparo Demora reduce Velocidad
  (6, -1, 6, 16), -- Disparo Demora reduce Velocidad
  (7, -1, 6, 18); -- Ataque Arena reduce Precisión