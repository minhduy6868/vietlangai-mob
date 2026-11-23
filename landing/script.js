(() => {
  const year = document.getElementById("year");
  if (year) year.textContent = String(new Date().getFullYear());

  const header = document.querySelector(".site-header");
  const menu = document.querySelector(".menu");
  const links = document.querySelector(".nav-links");
  const art = document.querySelector(".hero-illustration");

  /**
   * Normalize legacy hash deep-links (/app/#/login) → path URLs (/app/login).
   */
  document.addEventListener("click", (event) => {
    const a = event.target.closest("a[href]");
    if (!a) return;
    const href = a.getAttribute("href") || "";
    if (!href.includes("/app/#")) return;
    event.preventDefault();
    const route = href.slice(href.indexOf("/app/#") + "/app/#".length);
    const path = route.startsWith("/") ? route : `/${route}`;
    const url = `/app${path}`;
    closeMenu();
    if (a.target === "_blank") window.open(url, "_blank");
    else window.location.assign(url);
  });

  const closeMenu = () => {
    links?.classList.remove("is-open");
    menu?.setAttribute("aria-expanded", "false");
  };

  const onScroll = () => {
    if (!header) return;
    header.classList.toggle("is-solid", window.scrollY > 12);
  };
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  menu?.addEventListener("click", () => {
    const open = !(menu.getAttribute("aria-expanded") === "true");
    menu.setAttribute("aria-expanded", open ? "true" : "false");
    links?.classList.toggle("is-open", open);
  });

  links?.querySelectorAll("a").forEach((a) => {
    a.addEventListener("click", () => {
      const href = a.getAttribute("href") || "";
      if (href.startsWith("#")) closeMenu();
    });
  });

  const sectionIds = ["top", "about", "features", "explore", "cta"];
  const navMap = new Map(
    [...(links?.querySelectorAll(":scope > a") || [])].map((a) => [
      a.getAttribute("href")?.replace("#", ""),
      a,
    ])
  );
  const syncActive = () => {
    let current = "top";
    for (const id of sectionIds) {
      const target =
        id === "top" ? document.querySelector(".hero") : document.getElementById(id);
      if (!target) continue;
      if (target.getBoundingClientRect().top <= 120) current = id;
    }
    navMap.forEach((el, id) => {
      el.classList.toggle("is-active", id === current);
    });
  };
  window.addEventListener("scroll", syncActive, { passive: true });
  syncActive();

  const enterEls = document.querySelectorAll("[data-enter]");
  if ("IntersectionObserver" in window) {
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          const el = entry.target;
          if (
            el.parentElement?.classList.contains("feature-grid") ||
            el.parentElement?.classList.contains("explore-grid")
          ) {
            const siblings = [...el.parentElement.children];
            el.style.setProperty("--stagger", `${siblings.indexOf(el) * 0.08}s`);
          }
          el.classList.add("is-in");
          io.unobserve(el);
        });
      },
      { threshold: 0.16, rootMargin: "0px 0px -8% 0px" }
    );
    enterEls.forEach((el) => io.observe(el));
  } else {
    enterEls.forEach((el) => el.classList.add("is-in"));
  }

  if (art && !window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    window.addEventListener(
      "scroll",
      () => {
        const rect = art.getBoundingClientRect();
        if (rect.bottom < 0 || rect.top > window.innerHeight) return;
        const progress = (window.innerHeight / 2 - rect.top) / window.innerHeight;
        art.style.translate = `0 ${Math.max(-18, Math.min(18, progress * 24))}px`;
      },
      { passive: true }
    );
  }
})();
