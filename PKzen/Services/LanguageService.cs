namespace PKzen.Services
{
    public class LanguageService
    {
        // Evento para notificar cambios de idioma
        public event EventHandler<string> LanguageChanged;

        // Idioma predeterminado
        private string _currentLanguage = "es";

        // Idiomas disponibles en la PokeAPI
        public static readonly Dictionary<string, string> AvailableLanguages = new Dictionary<string, string>
        {
            { "es", "Español" },
            { "en", "English" },
            { "ja", "日本語" },
            { "ko", "한국어" },
            { "fr", "Français" },
            { "de", "Deutsch" },
            { "it", "Italiano" },
            { "zh-Hans", "简体中文" },
            { "zh-Hant", "繁體中文" }
        };

        public string CurrentLanguage
        {
            get => _currentLanguage;
            set
            {
                if (_currentLanguage != value && AvailableLanguages.ContainsKey(value))
                {
                    _currentLanguage = value;
                    LanguageChanged?.Invoke(this, _currentLanguage);
                }
            }
        }
    }
}
