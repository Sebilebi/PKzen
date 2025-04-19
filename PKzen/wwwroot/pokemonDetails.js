document.addEventListener('DOMContentLoaded', function () {
    let lastScrollTop = 0;
    const initialTop = -334;
    const finalTop = 20;

    const observer = new MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
            if (mutation.addedNodes.length) {
                mutation.addedNodes.forEach(function (node) {
                    if (node.classList && node.classList.contains('pokemon-detail')) {
                        const pokemonDetailElement = node;
                        pokemonDetailElement.style.top = `${initialTop}px`;

                        window.addEventListener('scroll', function () {
                            let scrollTop = window.pageYOffset || document.documentElement.scrollTop;

                            let delta = scrollTop - lastScrollTop;
                            let currentTop = parseFloat(pokemonDetailElement.style.top);

                            if (delta > 0) {
                                // Scroll hacia abajo
                                currentTop = Math.max(initialTop, currentTop - delta);
                            } else {
                                // Scroll hacia arriba
                                currentTop = Math.min(finalTop, currentTop - delta);
                            }

                            pokemonDetailElement.style.top = `${currentTop}px`;
                            lastScrollTop = scrollTop <= 0 ? 0 : scrollTop; // Para evitar valores negativos
                        });
                    }
                });
            }
        });
    });

    observer.observe(document.body, { childList: true, subtree: true });
});
