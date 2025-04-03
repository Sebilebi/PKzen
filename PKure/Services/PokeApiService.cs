using PKure.Mapping;
using PKure.Models;
using PKure.Models.ViewModel;
using System.Net.Http;
using System.Net.Http.Json;

namespace PKure.Services
{
    public class PokeApiService
    {
        private readonly HttpClient _httpClient;

        public PokeApiService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        // Obtiene los primeros 20 Pokémon y los mapea a PokemonViewModel.
        public async Task<List<PokemonViewModel>> GetFirst20PokemonAsync()
        {
            var listResponse = await _httpClient.GetFromJsonAsync<PokemonListResponse>(PokeApiEndpoints.PokemonList);
            if (listResponse?.Results == null)
                return new List<PokemonViewModel>();

            var detailTasks = listResponse.Results
                .Select(item => _httpClient.GetFromJsonAsync<Pokemon>(item.Url))
                .ToArray();

            var apiPokemons = await Task.WhenAll(detailTasks);
            return apiPokemons.Select(p => PokemonMapper.MapToViewModel(p)).ToList();
        }
    }
}