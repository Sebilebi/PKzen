using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Interop;

namespace PKure.Components.Layout
{
    public partial class MainLayout
    {

        [Inject] public NavigationManager navigationManager { get; set; }
        private const int WM_NCLBUTTONDOWN = 0x00A1;
        private const int HTCAPTION = 2;

        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();

        [DllImport("user32.dll")]
        public static extern IntPtr SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        // Obtiene la ventana principal de WPF.
        private System.Windows.Window GetCurrentWindow() => System.Windows.Application.Current.MainWindow;

        protected override void OnInitialized()
        {
            // Si la ruta actual está vacía ("/"), redirige a /pokedex
            var uri = navigationManager.ToBaseRelativePath(navigationManager.Uri).TrimEnd('/');
            if (string.IsNullOrEmpty(uri))
            {
                navigationManager.NavigateTo("/pokedex");
            }
        }

        private void OnTitleBarClick(MouseEventArgs e)
        {
            try
            {
                var window = GetCurrentWindow();
                if (window != null)
                {
                    window.Dispatcher.Invoke(() =>
                    {
                        // Libera la captura y simula el mensaje de título para iniciar el movimiento.
                        ReleaseCapture();
                        var helper = new WindowInteropHelper(window);
                        SendMessage(helper.Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
                    });
                }
            }
            catch
            {
                // En escenarios donde no sea posible arrastrar la ventana.
            }
        }

        /// <summary>
        /// Devuelve "active" si la ruta actual coincide con href.
        /// </summary>
        /// <param name="href">La ruta a comparar, ej. "/pokedex".</param>
        /// <returns>"active" o cadena vacía.</returns>
        private string IsActive(string href)
        {
            // Obtiene la URI actual y extrae la parte relativa.
            var uri = navigationManager.ToBaseRelativePath(navigationManager.Uri).TrimEnd('/');
            href = href.TrimStart('/').TrimEnd('/');

            // Si la URI actual es vacía, significa que estamos en la raíz.
            if (string.IsNullOrEmpty(uri) && string.IsNullOrEmpty(href))
                return "active";

            return uri.Equals(href, System.StringComparison.InvariantCultureIgnoreCase) ? "active" : "";
        }
    }
}
