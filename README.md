# BCSP Solver — Boolean Constraint Satisfaction Problem

A C implementation and experimental comparison of two algorithms for the
**Boolean Constraint Satisfaction Problem (BCSP)**, also known as **k-SAT**
or **Propositional Satisfiability**.

> Εργασία Τεχνητής Νοημοσύνης — Ικανοποιησιμότητα προτάσεων στην προτασιακή λογική.

---

## Table of Contents

- [Overview](#overview)
- [Algorithms](#algorithms)
- [Project Structure](#project-structure)
- [Building](#building)
- [Usage](#usage)
- [Input / Output Format](#input--output-format)
- [Experiments](#experiments)
- [Results](#results)
- [Background](#background)
- [License](#license)

---

## Overview

Given a set of `N` propositional symbols `P1, P2, …, PN` and a set of `M`
clauses `C1, C2, …, CM`, each of the form

    Cj = Lj1 ∨ Lj2 ∨ … ∨ LjK

where each literal `Ljk` is either `Pi` or `¬Pi`, the goal is to find a
truth assignment to the symbols such that **all clauses are satisfied**.

This is the classic **k-SAT** problem, a canonical **NP-complete** problem.

This repository provides:

- A solver (`bcsp.c`) implementing two algorithms.
- A random instance generator (`bcsp_generate.c`).
- A solution validator (`bcsp_validate.c`).
- An experimental study of the **satisfiability phase transition** around the
  critical ratio `M/N`.

---

## Algorithms

### 1. Hill Climbing with Restarts (stochastic local search)

1. Assign random truth values to all `Pi`.
2. Count unsatisfied clauses `T0`.
3. If `T0 = 0`, return the assignment.
4. For each `Pi`, compute how many clauses would become unsatisfied if `Pi`
   were flipped. Pick the flip that reduces the count the most.
5. If no improving flip exists, restart from a new random assignment.
6. Stop after `NOF_RESTARTS` unsuccessful restarts (or a time limit).

### 2. Depth-First Search (systematic backtracking)

1. Push the empty node onto a stack.
2. Pop a node, generate valid children (assign next symbol `True`/`False`).
3. If a child is a full solution, return it.
4. Otherwise push children onto the stack.
5. If the stack empties, report **UNSAT**.

DFS guarantees a correct answer but can be exponentially slow on hard instances.
Hill climbing is fast on satisfiable instances but is **incomplete** — it may
never terminate on UNSAT instances.

---

## Project Structure

    .
    ├── bcsp.c              # Main solver (hill + depth)
    ├── bcsp_generate.c     # Random instance generator
    ├── bcsp_validate.c     # Solution validator
    ├── Makefile            # Build rules
    ├── inputs/             # Sample input files
    ├── outputs/            # Sample output files
    ├── experiments/        # Scripts and data for the plots
    └── README.md

---

## Building

### Using the Makefile

    make

This produces `bcsp`, `bcsp_generate`, and `bcsp_validate`.

### Manually with gcc

    gcc -O2 -o bcsp bcsp.c
    gcc -O2 -o bcsp_generate bcsp_generate.c
    gcc -O2 -o bcsp_validate bcsp_validate.c

Tested with `gcc` on Linux and MinGW on Windows.

---

## Usage

### Solve an instance

    ./bcsp hill  input-file output-file
    ./bcsp depth input-file output-file

- `hill`  → hill climbing with restarts
- `depth` → depth-first search

### Generate a random instance

    ./bcsp_generate N M K output-file

Example — 10 symbols, 43 clauses, 3 literals per clause:

    ./bcsp_generate 10 43 3 inputs/sample_10_43_3.txt

### Validate a solution

    ./bcsp_validate input-file output-file

Prints `VALID` if the assignment satisfies all clauses, otherwise `INVALID`.

---

## Input / Output Format

### Input

    N M K
    L11 L12 ... L1K
    L21 L22 ... L2K
    ...
    LM1 LM2 ... LMK

Each literal is an integer in `[-N, -1] ∪ [1, N]`:

- `+i` → `Pi`
- `-i` → `¬Pi`

**Example** (`N = 5, M = 7, K = 3`):

    5 7 3
    1 3 -4
    2 4 5
    -1 2 -5
    1 -2 4
    -3 -4 5
    -2 -3 -4
    1 2 -3

### Output

A single line with `N` values, each `-1` (False) or `+1` (True):

    1 1 -1 -1 1

This corresponds to `P1=True, P2=True, P3=False, P4=False, P5=True`.

---

## Experiments

The goal is to find the **critical ratio `M/N`** at which random k-SAT
instances transition from mostly satisfiable to mostly unsatisfiable,
and to compare the runtime of the two algorithms around that point.

### Suggested methodology

For `K > 3` (e.g. `K = 4`), fix `N` (e.g. `N = 20`) and vary `M` so that
`M/N` sweeps a range (e.g. `1` to `8`).

For each value of `M/N`:

1. Generate **at least 10 random instances**.
2. Solve each with **DFS** once.
3. Solve each with **hill climbing** five times, record the average time.
4. Record the fraction of satisfiable instances.

### Plots

1. **Probability of satisfiability** vs `M/N`.
2. **Average runtime** vs `M/N` for both algorithms.

Both curves typically peak sharply at the critical ratio
(e.g. around `M/N ≈ 4.26` for `K = 3`).

### Reproducing

    cd experiments
    bash run_experiments.sh
    python3 plot_results.py

---

## Results

For `K = 3`, the classic phase transition is observed around `M/N ≈ 4.26`:

- Below the threshold → almost all instances are satisfiable.
- Above the threshold → almost all instances are unsatisfiable.
- **At the threshold** → runtime spikes for both algorithms.

| M/N  | P(satisfiable) | Avg DFS time (ms) | Avg Hill time (ms) |
|------|----------------|-------------------|--------------------|
| 2.0  | 1.00           | 1                 | 1                  |
| 3.0  | 1.00           | 2                 | 1                  |
| 4.0  | 0.95           | 40                | 8                  |
| 4.26 | 0.50           | 1800              | 400                |
| 5.0  | 0.05           | 200               | 60                 |
| 6.0  | 0.00           | 10                | 5                  |

*(Replace with your own measurements.)*

---

## Background

This project was completed as part of an **Artificial Intelligence** course
assignment on **propositional satisfiability**. It illustrates:

- The NP-completeness of SAT.
- The difference between **incomplete** (hill climbing) and **complete** (DFS)
  search algorithms.
- The **phase transition** phenomenon in random CSPs.
- Practical trade-offs between local search and systematic search.

---

## License

MIT License — see `LICENSE` for details.

---

## Acknowledgements

- Course: Τεχνητή Νοημοσύνη, Πανεπιστήμιο Μακεδονίας.
- Algorithms based on standard SAT literature (DPLL, WalkSAT, GSAT).
