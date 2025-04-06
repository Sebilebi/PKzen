using PKure.Models;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.RegularExpressions;

namespace PKure.Services
{
    public class PokeApiService
    {
        private readonly HttpClient _httpClient;
        private readonly LanguageService _languageService;

        public PokeApiService(HttpClient httpClient, LanguageService languageService)
        {
            _httpClient = httpClient;
            _languageService = languageService;

            // Suscribirse al evento de cambio de idioma para actualizar los datos
            _languageService.LanguageChanged += async (sender, language) =>
            {
                // Aquí implementar una lógica para recargar los datos cuando cambia el idioma
            };
        }

        // Obtiene los primeros 20 Pokémon con datos localizados.
        public async Task<List<Pokemon>> GetFirst20PokemonAsync()
        {
            var listResponse = await _httpClient.GetFromJsonAsync<PokemonListResponse>(PokeApiEndpoints.PokemonList);
            if (listResponse?.Results == null)
                return new List<Pokemon>();

            var detailTasks = listResponse.Results
                .Select(item => GetPokemonWithLocalizedDataAsync(item.Name))
                .ToArray();

            var apiPokemons = await Task.WhenAll(detailTasks);
            return apiPokemons.ToList();
        }

        // Obtiene un Pokémon por nombre o id con datos localizados.
        public async Task<Pokemon> GetPokemonWithLocalizedDataAsync(string nameOrId)
        {
            // Obtener datos básicos del Pokémon
            var pokemon = await _httpClient.GetFromJsonAsync<Pokemon>(PokeApiEndpoints.GetPokemonDetailUrl(nameOrId));
            if (pokemon == null)
                return null;

            // Obtener datos de la especie (contiene nombres localizados)
            var speciesUrl = pokemon.Species.Url;
            var species = await _httpClient.GetFromJsonAsync<PokemonSpecies>(speciesUrl);
            pokemon.SpeciesDetails = species;

            // Obtener datos localizados para cada tipo
            var typeTasks = pokemon.Types.Select(async type =>
            {
                var typeDetails = await _httpClient.GetFromJsonAsync<TypeDetails>(type.Type.Url);
                type.Details = typeDetails;
                return type;
            }).ToArray();
            await Task.WhenAll(typeTasks);

            // Obtener datos localizados para cada habilidad
            var abilityTasks = pokemon.Abilities.Select(async ability =>
            {
                var abilityDetails = await _httpClient.GetFromJsonAsync<AbilityDetails>(ability.AbilityInfo.Url);
                ability.Details = abilityDetails;
                return ability;
            }).ToArray();
            await Task.WhenAll(abilityTasks);

            // Obtener datos localizados para cada estadística
            var statTasks = pokemon.Stats.Select(async stat =>
            {
                var statDetails = await _httpClient.GetFromJsonAsync<StatDetails>(stat.StatInfo.Url);
                stat.Details = statDetails;
                return stat;
            }).ToArray();
            await Task.WhenAll(statTasks);

            // Obtener la cadena de evolución si está disponible
            if (species.EvolutionChainReference != null)
            {
                var evolutionChainId = ExtractIdFromUrl(species.EvolutionChainReference.Url);
                var evolutionChain = await _httpClient.GetFromJsonAsync<EvolutionChain>(
                    PokeApiEndpoints.GetEvolutionChainUrl(evolutionChainId));

                pokemon.EvolutionChain = evolutionChain;

                // Obtener datos localizados para cada especie en la cadena de evolución
                await EnrichEvolutionChainWithLocalizedData(evolutionChain.Chain);
            }

            return pokemon;
        }

        // Método auxiliar para extraer el ID de una URL
        private string ExtractIdFromUrl(string url)
        {
            var match = Regex.Match(url, @"/(\d+)/?$");
            return match.Success ? match.Groups[1].Value : "";
        }

        // Método para enriquecer la cadena de evolución con datos localizados
        private async Task EnrichEvolutionChainWithLocalizedData(EvolutionChainLink chainLink)
        {
            // Obtener datos de la especie
            var speciesId = ExtractIdFromUrl(chainLink.Species.Url);
            var species = await _httpClient.GetFromJsonAsync<PokemonSpecies>(
                PokeApiEndpoints.GetPokemonSpeciesUrl(speciesId));
            chainLink.SpeciesDetails = species;

            // Procesar recursivamente las evoluciones
            foreach (var evolution in chainLink.EvolvesTo)
            {
                await EnrichEvolutionChainWithLocalizedData(evolution);
            }
        }
    }
}