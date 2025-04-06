namespace PKure.Services
{
    public static class PokeApiEndpoints
    {
        public const string BaseUrl = "https://pokeapi.co/api/v2/";

        // Endpoint para obtener los primeros 20 Pokémon.
        public const string PokemonList = BaseUrl + "pokemon/?limit=20";

        // Método para obtener el endpoint de detalle de un Pokémon por nombre o id.
        public static string GetPokemonDetailUrl(string nameOrId) => $"{BaseUrl}pokemon/{nameOrId}";
    }
}
