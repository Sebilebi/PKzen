using Microsoft.Extensions.DependencyInjection;
using System.Net.Http;
using System.Windows;

namespace PKure
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            var serviceCollection = new ServiceCollection();
            serviceCollection.AddWpfBlazorWebView();

            // Registrar HttpClient.
            serviceCollection.AddScoped(sp => new HttpClient());

            // Registrar nuestro servicio de la PokeApi.
            serviceCollection.AddScoped<Services.PokeApiService>();

            Resources.Add("services", serviceCollection.BuildServiceProvider());

            InitializeComponent();
        }
    }
}