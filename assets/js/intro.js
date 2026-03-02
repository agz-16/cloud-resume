document.addEventListener("DOMContentLoaded", function () {
  new Typed('#typed', {
    strings: [
      'Cloud Engineer',
      'Cloud Consultant',
      'Pre-Sales Engineer'
    ],
    typeSpeed: 55,
    backSpeed: 35,
    backDelay: 1200,
    loop: true,
    smartBackspace: true
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const folders = document.querySelectorAll(".intro-folders .folder");

  folders.forEach((folder) => {
    folder.addEventListener("toggle", () => {
      if (!folder.open) return;

      folders.forEach((other) => {
        if (other !== folder) other.removeAttribute("open");
      });
    });
  });
});

