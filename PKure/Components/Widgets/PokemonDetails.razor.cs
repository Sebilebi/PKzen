using System.Globalization;
using PKure.Models;

namespace PKure.Components.Widgets
{
    public partial class PokemonDetails
    {
        private readonly int[] maxStats = { 255, 190, 250, 194, 250, 200 };

        private async Task HandleClose()
        {
            await OnClose.InvokeAsync();
        }

        private List<(string Name, string Level)> GetEvolutionStages(EvolutionChainLink chainLink, string level = "")
        {
            var stages = new List<(string Name, string Level)>
            {
                (chainLink.SpeciesDetails?.GetLocalizedName(LanguageService.CurrentLanguage) ?? chainLink.Species.Name, level)
            };

            foreach (var evolvesTo in chainLink.EvolvesTo)
            {
                string evolutionLevel = "Lvl ";
                if (evolvesTo.EvolutionDetails?.FirstOrDefault()?.MinLevel != null)
                {
                    evolutionLevel += evolvesTo.EvolutionDetails.First().MinLevel.Value.ToString();
                }
                else
                {
                    evolutionLevel += evolvesTo.SpeciesDetails?.GetLocalizedName(LanguageService.CurrentLanguage) ?? evolvesTo.Species.Name;
                }

                stages.AddRange(GetEvolutionStages(evolvesTo, evolutionLevel));
            }

            return stages;
        }

        private (string Percentage, string Color) GetStatPercentageAndColor(int statIndex, int statValue)
        {
            double percentage = (double)statValue / 180 * 100;
            string formattedPercentage = percentage.ToString("F2", CultureInfo.InvariantCulture);

            string color = statValue switch
            {
                <= 30 => "var(--stat-very-low)",
                <= 60 => "var(--stat-low)",
                <= 90 => "var(--stat-medium)",
                <= 120 => "var(--stat-high)",
                <= 150 => "var(--stat-very-high)",
                _ => "var(--stat-max)"
            };

            return (formattedPercentage, color);
        }
    }
}
