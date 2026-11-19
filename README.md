# Xpedition Parts Importer

A collection of Ruby scripts for parsing component CSV tables from suppliers and manufacturers (such as **DigiKey**, **Nippon Chemi-Con**, and **WIMA**) and generating **Databook** tables with IPC / non-IPC cell mappings for **Mentor Xpedition**.

## Features

- **Multi-source CSV parsing**: Extracts and normalizes part parameters (capacitance, rated voltage, tolerance, temperature range, dimensions, package, datasheet/image links, etc.) from DigiKey and manufacturer catalogs.
- **Unit & Value Normalization**: Converts string representations of capacitance, voltage, tolerances, and physical dimensions into standardized numerical values.
- **Mentor Xpedition Cell Mapping**: Maps parsed components to IPC and non-IPC footprint cell formats (e.g., `IPC_CAPAE_1`, `NONIPC_CAPS`, `NONIPC_CAPAER_1`, `NONIPC_CAPAER_2`).
- **Databook Table Generation**: Outputs structured tables ready for integration into Mentor Xpedition Databook.

## Requirements

- **Ruby** (standard library: `csv`, `optparse` — no external gems required)

## Usage

Run the converter scripts from the repository directory (so local helper modules like `digikey_cap_tools` and `mentor_*_cell` are in `$LOAD_PATH`):

```bash
ruby <script_name>.rb --type digikey --cell_format IPC_CAPAE_1 [options] <input.csv>
```

### Supported Input Types (`--type`)
- `digikey` — DigiKey parametric search CSV exports
- `chemicon` — Nippon Chemi-Con catalog CSV tables

### Supported Cell Formats (`--cell_format`)
- `IPC_CAPAE_1`
- `NONIPC_CAPS`
- `NONIPC_CAPAER_1`
- `NONIPC_CAPAER_2`

## License

MIT
