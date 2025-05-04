using System.Globalization;

namespace PKzen.Components.Widgets
{
    public partial class PokemonDetails
    {
        private async Task HandleClose()
        {
            await OnClose.InvokeAsync();
        }

        private (string Percentage, string Color) GetStatPercentageAndColor(int statValue)
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
