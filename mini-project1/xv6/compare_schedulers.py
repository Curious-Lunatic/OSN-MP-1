import sys
import re

def parse_procstats(path):
    rows = []
    with open(path) as f:
        for line in f:
            m = re.search(r'PROCSTATS,(\d+),([^,]+),(\d+),(\d+),(\d+),(\d+)', line)
            if m:
                pid, name, creation, first_run, end, cpu_ticks = m.groups()
                rows.append({
                    'pid': int(pid), 'name': name,
                    'creation': int(creation), 'first_run': int(first_run),
                    'end': int(end), 'cpu_ticks': int(cpu_ticks),
                })
    return rows

def compute_metrics(rows):
    turnaround, waiting, response = [], [], []
    for r in rows:
        t = r['end'] - r['creation']
        resp = r['first_run'] - r['creation']
        wait = t - r['cpu_ticks']
        turnaround.append(t)
        waiting.append(wait)
        response.append(resp)
    n = len(rows) or 1
    return sum(turnaround)/n, sum(waiting)/n, sum(response)/n

def main():
    if len(sys.argv) != 4:
        print("usage: compare_schedulers.py <rr.txt> <fifo.txt> <mlfq.txt>")
        sys.exit(1)

    labels = ['RR', 'FIFO', 'MLFQ']
    print(f"{'Scheduler':<10}{'Turnaround':<14}{'Waiting':<12}{'Response':<12}")
    for label, path in zip(labels, sys.argv[1:]):
        rows = parse_procstats(path)
        ta, wt, rt = compute_metrics(rows)
        print(f"{label:<10}{ta:<14.2f}{wt:<12.2f}{rt:<12.2f}")

if __name__ == "__main__":
    main()