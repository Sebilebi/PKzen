document.addEventListener('DOMContentLoaded', function () {
    let lastScrollTop = 0;

    const observer = new MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
            if (mutation.addedNodes.length) {
                mutation.addedNodes.forEach(function (node) {
                    if (node.classList && node.classList.contains('pokemon-detail')) {
                        console.log('Elemento pokemon-detail encontrado');
                        const pokemonDetailElement = node;

                        window.addEventListener('scroll', function () {
                            let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                            console.log('ScrollTop actual:', scrollTop);
                            if (scrollTop > lastScrollTop) {
                                // Scroll hacia abajo
                                console.log('Scroll hacia abajo');
                                pokemonDetailElement.style.top = '-334px';
                            } else {
                                // Scroll hacia arriba
                                console.log('Scroll hacia arriba');
                                pokemonDetailElement.style.top = '20px';
                            }
                            lastScrollTop = scrollTop <= 0 ? 0 : scrollTop; // Para evitar valores negativos
                            console.log('Último ScrollTop:', lastScrollTop);
                        });
                    }
                });
            }
        });
    });

    observer.observe(document.body, { childList: true, subtree: true });
});
