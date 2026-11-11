(() => {
  const year = document.getElementById("year");
  if (year) year.textContent = String(new Date().getFullYear());

  const nav = document.querySelector(".nav");
  const menu = document.querySelector(".menu");
  const links = document.querySelector(".nav-links");
  const video = document.getElementById("intro");
  const muteBtn = document.querySelector(".film-mute");

  const onScroll = () => {
    if (!nav) return;
    nav.classList.toggle("is-solid", window.scrollY > 24);
  };
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  menu?.addEventListener("click", () => {
    const open = links?.classList.toggle("is-open");
    menu.setAttribute("aria-expanded", open ? "true" : "false");
  });

  links?.querySelectorAll("a").forEach((a) => {
    a.addEventListener("click", () => {
      links.classList.remove("is-open");
      menu?.setAttribute("aria-expanded", "false");
    });
  });

  muteBtn?.addEventListener("click", () => {
    if (!video) return;
    const muted = video.muted;
    video.muted = !muted;
    muteBtn.textContent = video.muted ? "Bật tiếng" : "Tắt tiếng";
    muteBtn.setAttribute("aria-pressed", video.muted ? "true" : "false");
    if (!video.muted) video.play().catch(() => {});
  });

  if (video) {
    video.play().catch(() => {
      // Autoplay can be blocked; poster still shows.
    });
  }

  document.querySelectorAll(".lang-item .lang-row").forEach((btn) => {
    btn.addEventListener("click", () => {
      const item = btn.closest(".lang-item");
      const panel = item?.querySelector(".lang-panel");
      if (!item || !panel) return;
      const open = item.classList.toggle("is-open");
      btn.setAttribute("aria-expanded", open ? "true" : "false");
      panel.hidden = !open;
      document.querySelectorAll(".lang-item").forEach((other) => {
        if (other === item) return;
        other.classList.remove("is-open");
        other.querySelector(".lang-row")?.setAttribute("aria-expanded", "false");
        const otherPanel = other.querySelector(".lang-panel");
        if (otherPanel) otherPanel.hidden = true;
      });
    });
  });

  const enterEls = document.querySelectorAll("[data-enter], .lang-item, .try, .flow-grid article");
  if ("IntersectionObserver" in window) {
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-in");
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.18 }
    );
    enterEls.forEach((el) => io.observe(el));
  } else {
    enterEls.forEach((el) => el.classList.add("is-in"));
  }
})();
