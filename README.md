# Boolean-Constraint-Satisfaction-Problem
Boolean Constraint Satisfaction Problem (BCSP/SAT) solver in C: hill climbing with restarts vs depth-first search, plus experiments on the satisfiability phase transition
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
