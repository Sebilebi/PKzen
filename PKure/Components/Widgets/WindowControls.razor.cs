using System.Windows;

namespace PKure.Components.Widgets
{
    public partial class WindowControls
    {
        // Obtiene la ventana principal de WPF.
        private System.Windows.Window GetCurrentWindow() => System.Windows.Application.Current.MainWindow;

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
