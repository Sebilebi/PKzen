using Microsoft.AspNetCore.Components.Web;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Interop;

namespace PKure.Components.TitleBar
{
    public partial class TitleBar
    {
        private const int WM_NCLBUTTONDOWN = 0x00A1;
        private const int HTCAPTION = 2;

        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();

        [DllImport("user32.dll")]
        public static extern IntPtr SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        // Obtiene la ventana principal de WPF.
        private System.Windows.Window GetCurrentWindow() => System.Windows.Application.Current.MainWindow;

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

        private void HandleMinimize()
        {
            var window = GetCurrentWindow();
            if (window != null)
            {
                SystemCommands.MinimizeWindow(window);
            }
        }

        private void HandleMaximizeRestore()
        {
            var window = GetCurrentWindow();
            if (window != null)
            {
                if (window.WindowState == WindowState.Normal)
                {
                    SystemCommands.MaximizeWindow(window);
                }
                else
                {
                    SystemCommands.RestoreWindow(window);
                }
            }
        }

        private void HandleClose()
        {
            var window = GetCurrentWindow();
            if (window != null)
            {
                SystemCommands.CloseWindow(window);
            }
        }
    }
}
