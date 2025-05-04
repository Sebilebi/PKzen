using Microsoft.Extensions.DependencyInjection;
using PKzen.Data;
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
            serviceCollection.AddBlazorWebViewDeveloperTools(); // Configurar el entorno de desarrollo para BlazorWebView.

            var dbConnection = Database.Instance; // Inicializar la conexión a la base de datos

            Resources.Add("services", serviceCollection.BuildServiceProvider());

            InitializeComponent();
        }
    }
}