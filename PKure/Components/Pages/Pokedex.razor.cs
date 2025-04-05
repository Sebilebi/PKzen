using Microsoft.AspNetCore.Components;
using PKure.Models.ViewModel;
using PKure.Services;

namespace PKure.Components.Pages
{
    public partial class Pokedex : ComponentBase
    {
        [Inject]
        private PokeApiService PokeService { get; set; }
        List<PokemonViewModel> pokemons;
        public PokemonDetailViewModel SelectedPokemon { get; set; } = null;

        protected override async Task OnInitializedAsync()
        {
            pokemons = await PokeService.GetFirst20PokemonAsync();
        }

        private void OnPokemonSelected(PokemonViewModel pokemon)
        {
            if (pokemon == null)
                return;

            PokemonDetailViewModel details = new PokemonDetailViewModel
            {
                Id = pokemon.Id,
                Name = pokemon.Name,
                ImageUrl = pokemon.ImageUrl,
                Types = pokemon.Type.Split('/').Select(t => t.Trim()).ToList(),
                Stats = new List<StatViewModel>()
            };

            SelectedPokemon = details;
        }


        private void CloseDetails()
        {
            SelectedPokemon = null;
        }
    }
}