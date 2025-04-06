namespace PKure.Services
{
    public static class PokeApiEndpoints
    {
        public const string BaseUrl = "https://pokeapi.co/api/v2/";

        // Endpoint para obtener los primeros 20 Pokémon.
        public const string PokemonList = BaseUrl + "pokemon/?limit=20";

        // Método para obtener el endpoint de detalle de un Pokémon por nombre o id.
        public static string GetPokemonDetailUrl(string nameOrId) => $"{BaseUrl}pokemon/{nameOrId}";

        // Método para obtener el endpoint de detalle de una especie de Pokémon por nombre o id.
        public static string GetPokemonSpeciesUrl(string nameOrId) => $"{BaseUrl}pokemon-species/{nameOrId}";

        // Método para obtener el endpoint de detalle de un tipo por nombre o id.
        public static string GetTypeUrl(string nameOrId) => $"{BaseUrl}type/{nameOrId}";

        // Método para obtener el endpoint de detalle de una habilidad por nombre o id.
        public static string GetAbilityUrl(string nameOrId) => $"{BaseUrl}ability/{nameOrId}";

        // Método para obtener el endpoint de detalle de una estadística por nombre o id.
        public static string GetStatUrl(string nameOrId) => $"{BaseUrl}stat/{nameOrId}";

        // Método para obtener el endpoint de detalle de un movimiento por nombre o id.
        public static string GetMoveUrl(string nameOrId) => $"{BaseUrl}move/{nameOrId}";

        // Método para obtener el endpoint de detalle de una cadena de evolución por id.
        public static string GetEvolutionChainUrl(string id) => $"{BaseUrl}evolution-chain/{id}";
    }
}