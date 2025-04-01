using PKure.Models;

namespace PKure.Mapping
{
    public static class PokemonMapper
    {
        public static PokemonViewModel MapToViewModel(Pokemon apiPokemon)
        {
            return new PokemonViewModel
            {
                Id = apiPokemon.Id,
                Name = char.ToUpper(apiPokemon.Name[0]) + apiPokemon.Name.Substring(1),
                ImageUrl = apiPokemon.ImageUrl,
                Type = (apiPokemon.Types != null && apiPokemon.Types.Any())
                        ? string.Join(" / ", apiPokemon.Types
                            .OrderBy(t => t.Slot)
                            .Select(t => char.ToUpper(t.Type.Name[0]) + t.Type.Name.Substring(1)))
                        : "N/A"
            };
        }
    }
}