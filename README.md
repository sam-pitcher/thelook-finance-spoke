# TheLook Finance Spoke Project

This is a dedicated **Departmental Spoke** Looker project for the Finance & Accounting Department, built on top of the Central Governed Hub (`thelook-antigravity`).

## Architecture
- **Imports**: `thelook-antigravity` via Looker Project Import (`manifest.lkml`).
- **Refinements**: `views/order_items_rfn.view.lkml` refines `+order_items` with tax liabilities and net revenue metrics.
- **Extensions**: `views/order_items_ext.view.lkml` creates `order_items_ext` for high-value audit reviews.
- **Model**: `models/thelook_finance.model.lkml` exposes finance-labeled explores with end-of-day caching rules.
