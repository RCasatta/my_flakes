# AGENTS.md - Guidelines for Coding Agents

## Overview
This repository (`my_flakes`) is a personal Nix flake collection that aggregates tools and services.
It does not contain source code directly but pulls in external flakes as packages.
The advantage of doing so it sharing the same version of nixpkgs and building tools when installing these services.

## Build & Commands

### Nix Flakes Commands
- **Update single input**: `nix flake update <input_name>` (e.g., `nix flake lock waterfalls`)
- **Enter development shell**: `nix develop`
- **Build all packages**: `nix build`
- **Build single package**: `nix build .#waterfalls`
- **Check format/syntax**: Nix uses standard formatting; no dedicated formatter

## Code Style Guidelines

### Nix Configuration (flake.nix)

#### Imports & Structure
- Use standard flake structure with `inputs` and `outputs` sections
- Follow the pattern: each input gets `.follows = "nixpkgs"` and `.follows = "flake-utils"` for consistency
- Keep inputs alphabetically ordered where possible
- Comment out inactive inputs rather than deleting them

#### Naming Conventions
- Package names use kebab-case (e.g., `esplora-enterprise-monitoring`)
- Variable names use camelCase within Nix expressions (e.g., `blocks_iterator_pkg`)
- Flake input names match upstream repository names

#### Formatting
- 2-space indentation for Nix code
- Logical grouping: inputs → outputs → system-specific definitions → package exports
- Keep related packages together in the outputs section
- Use blank lines to separate logical sections

#### Error Handling
- Nix is declarative; errors are runtime failures during evaluation
- Ensure all referenced inputs exist and have correct URLs
- Validate URLs before committing (test with `nix flake lock`)

## Cursor/Copilot Rules
No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` files exist in this repository. Follow the Nix flake conventions above.

## General Guidelines for Agents
1. When modifying flake.nix, ensure all URL changes are valid before committing
2. Package names must match the upstream repository structure
3. Maintain consistency with existing input patterns (inputs follow nixpkgs and flake-utils)
4. This is a meta-flake; actual source code lives in external repositories
5. When adding new packages, include both inputs section and outputs section entries
