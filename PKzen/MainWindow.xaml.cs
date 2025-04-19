using Microsoft.Extensions.DependencyInjection;
using System.Net.Http;
using System.Windows;

namespace PKzen
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

            // Registrar servicio de la PokeApi.
            serviceCollection.AddScoped<Services.PokeApiService>();

            // Registrar servicio del idioma.
            serviceCollection.AddScoped<Services.LanguageService>();

            // Configurar el entorno de desarrollo para BlazorWebView.
            serviceCollection.AddBlazorWebViewDeveloperTools();

            Resources.Add("services", serviceCollection.BuildServiceProvider());

            InitializeComponent();
        }
    }
}