import os
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.ticker import FixedFormatter, FixedLocator, NullLocator

BLUE, DARK, GREY, LIGHT = "#4285F4", "#212121", "#595959", "#EEEEEE"
BANDS = ["#DCE8FD", "#FFF1DD", "#E6F4EA", "#FCE8E6"]

args = [a for a in sys.argv[1:] if not a.startswith("--")]
path = args[0] if args else "data.txt"
show_caches = "--caches" in sys.argv
cpu = int(args[1]) if len(args) > 1 else 0

kb, ns = [], []
with open(path) as f:
    for line in f:
        if line.startswith("#") or not line.strip():
            continue
        a, b = line.split()
        kb.append(int(a))
        ns.append(float(b))


def label(k):
    return f"{k // 1024}M" if k >= 1024 else f"{k}K"


def cache_sizes(cpu):
    sizes = {}
    base = f"/sys/devices/system/cpu/cpu{cpu}/cache"
    for d in sorted(os.listdir(base)):
        if not d.startswith("index"):
            continue
        read = lambda name: open(os.path.join(base, d, name)).read().strip()
        if read("type") == "Instruction":
            continue
        size = read("size")
        k = int(size[:-1]) * (1024 if size.endswith("M") else 1)
        sizes[int(read("level"))] = k
    return [sizes[l] for l in sorted(sizes)]


plt.rcParams.update({"font.size": 13, "axes.edgecolor": GREY, "axes.labelcolor": DARK,
                     "xtick.color": GREY, "ytick.color": GREY,
                     "axes.spines.top": False, "axes.spines.right": False})
fig, ax = plt.subplots(figsize=(9, 5))

lo, hi = kb[0] / 1.4, kb[-1] * 1.4
if show_caches:
    edges = [lo] + [s for s in cache_sizes(cpu) if lo < s < hi] + [hi]
    names = [f"L{i + 1}" for i in range(len(edges) - 2)] + ["DRAM"]
    for i in range(len(edges) - 1):
        ax.axvspan(edges[i], edges[i + 1], color=BANDS[i % len(BANDS)], zorder=0)
        ax.text((edges[i] * edges[i + 1]) ** 0.5, 0.04, names[i], transform=ax.get_xaxis_transform(),
                ha="center", fontsize=14, color=DARK, weight="bold")

ax.plot(kb, ns, "-o", color=BLUE, lw=3, ms=6, zorder=3)
ax.set_xscale("log", base=2)
ax.set_yscale("log")
ax.set_xlim(lo, hi)
ticks = [k for k in kb if k & (k - 1) == 0][::2]
ax.xaxis.set_major_locator(FixedLocator(ticks))
ax.xaxis.set_major_formatter(FixedFormatter([label(k) for k in ticks]))
ax.xaxis.set_minor_locator(NullLocator())
yt = [y for y in [0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500] if min(ns) / 2 <= y <= max(ns) * 2]
ax.yaxis.set_major_locator(FixedLocator(yt))
ax.yaxis.set_major_formatter(FixedFormatter([f"{y:g}" for y in yt]))
ax.yaxis.set_minor_locator(NullLocator())
ax.set_ylim(min(ns) / 1.6, max(ns) * 1.5)
ax.set_xlabel("array size")
ax.set_ylabel("ns per read")
ax.grid(axis="y", color=LIGHT)

out = os.path.join(os.path.dirname(os.path.abspath(path)), "latency.png")
fig.savefig(out, dpi=150, bbox_inches="tight", facecolor="white")
print("saved", out)
