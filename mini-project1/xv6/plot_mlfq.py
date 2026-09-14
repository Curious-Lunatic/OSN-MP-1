import sys
import re
import matplotlib.pyplot as plt

def parse_log(path):
    ticks, pids, queues = [], [], []
    boosts = []
    with open(path) as f:
        for line in f:
            m = re.search(r'MLFQLOG,(\d+),(\d+),(\d+)', line)
            if m:
                ticks.append(int(m.group(1)))
                pids.append(int(m.group(2)))
                queues.append(int(m.group(3)))
                continue
            m = re.search(r'MLFQBOOST,(\d+)', line)
            if m:
                boosts.append(int(m.group(1)))
    return ticks, pids, queues, boosts

def main():
    if len(sys.argv) != 3:
        print("usage: plot_mlfq.py <qemu_log_file> <iiit_username>")
        sys.exit(1)

    logfile, username = sys.argv[1], sys.argv[2]
    ticks, pids, queues, boosts = parse_log(logfile)

    if not ticks:
        print("No MLFQLOG lines found -- did you run with MLFQ_DEBUG=1?")
        sys.exit(1)

    unique_pids = sorted(set(pids))
    cmap = plt.get_cmap('tab10')
    pid_color = {pid: cmap(i % 10) for i, pid in enumerate(unique_pids)}

    fig, ax = plt.subplots(figsize=(12, 6))

    for pid in unique_pids:
        xs = [t for t, p in zip(ticks, pids) if p == pid]
        ys = [q for q, p in zip(queues, pids) if p == pid]
        # Use a step plot to draw continuous lines between state changes
        ax.step(xs, ys, where='post', marker='o', markersize=5, 
                color=pid_color[pid], label=f"PID {pid}", linewidth=1.5)

    for b in boosts:
        ax.axvline(x=b, color='gray', linestyle='--', alpha=0.5)

    ax.set_xlabel("Elapsed timer ticks")
    ax.set_ylabel("MLFQ queue (0 highest, 3 lowest)")
    ax.set_yticks([0, 1, 2, 3])
    
    # Invert Y axis so 0 is at the top
    ax.invert_yaxis()
    
    ax.set_title("MLFQ Queue Timeline")
    ax.legend(title="Process", loc='lower left')

    fig.text(0.99, 0.95, username, ha='right', va='top',
              fontsize=15, color='gray', alpha=0.5, rotation=0)

    plt.grid(True, linestyle=':', alpha=0.6)
    plt.tight_layout()
    out = "mlfq_timeline.png"
    plt.savefig(out, dpi=150)
    print(f"Saved {out}")

if __name__ == "__main__":
    main()