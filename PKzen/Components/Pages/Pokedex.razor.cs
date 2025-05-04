using PKzen.DataAccess;
using PKzen.Models;

namespace PKzen.Components.Pages
{
    public partial class Pokedex
    {
        private List<Pokemon> pokemons;
        public Pokemon? SelectedPokemon { get; set; } = null;

        protected override async Task OnInitializedAsync()
        {
            var pokemonDal = new PokemonDal();
            pokemons = pokemonDal.GetAll().ToList();
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