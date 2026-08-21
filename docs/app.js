const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry, i) => {
    if (entry.isIntersecting) {
      setTimeout(() => entry.target.classList.add('visible'), i * 80);
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.component, .tax-item, .int-item, .stack-item').forEach(el => {
  observer.observe(el);
});

const nodes = document.querySelectorAll('.pipe-node');
let current = 0;
function cyclePipeline() {
  nodes.forEach(n => n.classList.remove('active'));
  nodes[current].classList.add('active');
  current = (current + 1) % nodes.length;
}
if (nodes.length) setInterval(cyclePipeline, 1200);
