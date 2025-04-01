using Microsoft.AspNetCore.Components;
using PKure.Models;
using PKure.Services;

namespace PKure.Components.Pages
{
    public partial class Pokedex : ComponentBase
    {
        [Inject]
        private PokeApiService PokeService { get; set; }
        List<PokemonViewModel> pokemons;

        protected override async Task OnInitializedAsync()
        {
            pokemons = await PokeService.GetFirst20PokemonAsync();
        }
    }
}
