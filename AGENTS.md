# Agent Guidelines for CUE Kubernetes Configuration

This repo (github.com/polo871209/cue-learning) provides reusable CUE definitions for Kubernetes deployments with security best practices.

## Commands
- **Validate**: `just validate` (all), `just validate-app <app>` (single app)
- **Export**: `just export <app>` (YAML output), `just export-all` (all apps)
- **Dry-run**: `just dry-run <app>`

## Project Structure
- **definitions/**: Reusable definitions (e.g., `#Deployment`). Import with `"github.com/polo871209/cue-learning/definitions"`
- **apps/**: Individual apps. Each has `config.cue`, resource files, and `stream.cue` for YAML export
- **External packages**: Kubernetes types from `"cue.dev/x/k8s.io/api/..."`

## Code Style
- Use `package app` for apps, `package definitions` for definitions
- Private fields: `_field`, exported definitions: `#Definition`
- Merge base definitions with app-specific config using `&`
- All deployments must: use non-root users (UID 10000+), read-only root filesystem, drop ALL capabilities, no "default" namespace
- Volumes required for writable paths (/tmp, /var/cache) when using read-only filesystem
