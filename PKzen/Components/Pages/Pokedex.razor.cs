using Microsoft.AspNetCore.Components;
using PKzen.Models;
using PKzen.Services;

namespace PKzen.Components.Pages
{
    public partial class Pokedex : ComponentBase
    {
        [Inject]
        private PokeApiService PokeService { get; set; }
        private List<Pokemon> pokemons;
        public Pokemon? SelectedPokemon { get; set; } = null;

        protected override async Task OnInitializedAsync()
        {
            pokemons = await PokeService.GetFirst20PokemonAsync();
        }

        private void OnPokemonSelected(Pokemon pokemon)
        {
            if (pokemon == null)
                return;

            SelectedPokemon = pokemon;
        }


        private void CloseDetails()
        {
            SelectedPokemon = null;
        }
    }
}