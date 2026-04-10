---
name: fulfillment-sop
description: >
  Standard operating procedures for end-to-end Figurio order fulfillment —
  from print file preparation and MCAE handoff, through QA inspection and
  branded packaging, to Zásilkovna shipping label generation and returns handling.
  Applies to both catalog figurines and AI custom "Prompt to Print" orders.
allowed-tools:
  - Read
  - Write
  - Grep
metadata:
  paperclip:
    tags:
      - operations
      - fulfillment
      - quality
      - shipping
---

# Fulfillment SOP

## When to Use

Invoke this skill when:
- Processing a new production batch for MCAE handoff
- Performing QA inspection on incoming figurines from MCAE
- Packaging and dispatching orders via Zásilkovna
- Handling a return or reprint request from a customer

---

## Order Types

| Type | Source | Key Difference |
|------|--------|---------------|
| Catalog | Customer selects existing figurine SKU | Print files are pre-validated, stored in production file library |
| AI Custom ("Prompt to Print") | Customer submits prompt; AI generates 3D model | Print file requires additional validation before handoff |

---

## Stage 1 — Print File Preparation

### Catalog Orders

1. Retrieve the validated `.3mf` or `.stl` print file from the production file library using the order's SKU.
2. Confirm file version matches the current approved revision (check revision log).
3. Group orders by size tier (Small / Medium / Large) for batch efficiency.
4. No reprep required unless MCAE flags a file issue on receipt.

### AI Custom Orders

1. Retrieve the AI-generated 3D model from the order record.
2. Run automated mesh validation checks (watertight mesh, minimum wall thickness ≥ 1.5 mm, no inverted normals). Flag failures immediately to the backend team.
3. Apply Figurio's standard orientation and support strategy template for the relevant size tier.
4. Export as `.3mf` with embedded color data (PolyJet requires per-voxel color encoding — confirm color profile is Stratasys J55 compatible).
5. Store the validated file in the production handoff folder with filename convention: `CUSTOM-{order_id}-{size_tier}-{YYYYMMDD}.3mf`.

---

## Stage 2 — MCAE Handoff

1. Compile the batch manifest — a CSV with columns: `order_id`, `type` (catalog/custom), `size_tier`, `filename`, `quantity`, `due_date`.
2. Upload print files and manifest to the agreed MCAE SFTP drop folder by **10:00 CET on business days**.
3. Send a handoff notification email to the MCAE production contact with the manifest attached.
4. Log the handoff time and batch ID in the fulfillment tracker (PostgreSQL `production_batches` table or ops spreadsheet).
5. Await MCAE file acknowledgement within 4 business hours (per vendor SLA). If no acknowledgement is received, follow up directly and log the delay.

### Handoff Checklist

- [ ] All files validated (mesh checks passed)
- [ ] Manifest CSV complete and accurate
- [ ] Files uploaded to SFTP before 10:00 CET
- [ ] Notification email sent to MCAE contact
- [ ] Batch logged in fulfillment tracker
- [ ] Acknowledgement received and recorded

---

## Stage 3 — Production Tracking

- Check MCAE production status daily via their portal or daily status email.
- Flag any batch approaching SLA breach (see `vendor-evaluation` skill for thresholds) and contact MCAE proactively.
- Maintain a "pending production" view in the fulfillment tracker showing expected completion date per batch.

---

## Stage 4 — QA Inspection (Incoming from MCAE)

All figurines are inspected before packaging. Do not skip QA for catalog orders — MCAE issues can affect any batch.

### Inspection Process

For each unit in the incoming delivery:

1. **Visual color check** — Compare against the approved reference render. Color deviation visible at normal viewing distance (≥ 30 cm) fails.
2. **Surface finish check** — Inspect display surfaces (front, top, sides) for support scarring, layer artifacts, or resin pooling. Any artifact on a display surface fails.
3. **Dimensional check** — Measure height against size tier spec:
   - Small: 7.5–8.5 cm
   - Medium: 14–16 cm
   - Large: 24–26 cm
4. **Structural integrity** — Flex test thin elements (weapon tips, wings, antennas). Any cracking or delamination fails.

### QA Outcomes

| Outcome | Action |
|---------|--------|
| Pass | Proceed to packaging |
| Fail — single unit | Set aside, log defect, request MCAE reprint for that unit |
| Fail — > 5% of batch | Reject full batch, escalate to MCAE, log SLA breach |

Record all QA outcomes in the fulfillment tracker: `order_id`, `pass/fail`, `defect_type` (if applicable), `inspector`, `date`.

---

## Stage 5 — Branded Packaging

1. Wrap figurine in acid-free tissue paper — full wrap, no exposed surfaces.
2. Place in size-appropriate Figurio branded box:
   - Small: 120×120×120 mm box
   - Medium: 200×200×200 mm box
   - Large: 320×320×320 mm box
3. Fill void space with branded crinkle paper filler (Figurio teal). No polystyrene peanuts.
4. Insert the printed order card (generated from order record — includes customer name, figurine name, and QR code linking to care instructions).
5. For AI Custom orders, also insert the "Your Figurio Story" card describing the AI generation process.
6. Seal box with Figurio branded tape.
7. Attach Zásilkovna shipping label to the largest flat face of the box.

---

## Stage 6 — Zásilkovna Shipping

1. Generate shipping labels via the Zásilkovna API integration (FastAPI service endpoint `/fulfillment/labels`). Input: list of `order_id` values from the current dispatch batch.
2. Confirm each label is generated with the correct:
   - Recipient name and address (pulled from order record)
   - Declared value (required for insurance — use order total in CZK)
   - Size/weight tier matching the package
3. Print labels and apply immediately to packaged boxes — do not stockpile unlabelled boxes.
4. Record tracking number against `order_id` in the fulfillment tracker and update order status to `shipped` in the Figurio backend.
5. Hand parcels to Zásilkovna courier or deposit at designated drop point by the daily cutoff time (confirm current cutoff with Zásilkovna account contact — typically 15:00 CET).
6. Trigger the customer shipping confirmation email (via Figurio backend — includes tracking number and Zásilkovna tracking link).

### Dispatch Checklist

- [ ] Labels generated via API (no manual label creation)
- [ ] Each label verified against order record
- [ ] Tracking numbers logged in fulfillment tracker
- [ ] Order status updated to `shipped`
- [ ] Parcels handed off before daily cutoff
- [ ] Customer shipping confirmation sent

---

## Stage 7 — Returns Handling

### Eligible Return Reasons

- Defective figurine (QA failure that passed undetected)
- Significant color mismatch vs. product images (catalog) or AI render preview (custom)
- Damaged in transit (Zásilkovna damage claim required)
- Wrong item received

### Process

1. Customer submits return request via Figurio support channel, including photos.
2. Head of Operations reviews photos and approves or rejects within 1 business day.
3. **Approved returns:**
   - Issue Zásilkovna return label to customer (via API — reverse shipment).
   - On receipt, confirm defect matches reported reason. If mismatch, escalate.
   - Initiate reprint (catalog) or re-generation + reprint (AI custom) at no charge.
   - Log root cause: `mcae_defect`, `transit_damage`, `fulfillment_error`, or `customer_expectation`.
4. **Transit damage:** File Zásilkovna damage claim within 5 business days of delivery. Attach customer photos and tracking record.
5. Log all returns in the returns register with root cause — reviewed monthly to identify recurring issues.

### Returns Do Not Apply To

- AI Custom orders where the delivered figurine matches the approved AI render preview — customers must review and approve the preview before production.

---

## Fulfillment Tracker Fields (Reference)

Key fields that must be populated at each stage:

| Field | Populated At |
|-------|-------------|
| `order_id` | Order creation |
| `order_type` (catalog/custom) | Order creation |
| `size_tier` | Order creation |
| `file_validated_at` | Stage 1 |
| `mcae_handoff_at` | Stage 2 |
| `mcae_acknowledged_at` | Stage 2 |
| `mcae_completed_at` | Stage 3 |
| `qa_result` | Stage 4 |
| `qa_defect_type` | Stage 4 (if failed) |
| `packaged_at` | Stage 5 |
| `tracking_number` | Stage 6 |
| `shipped_at` | Stage 6 |
| `return_reason` | Stage 7 (if applicable) |

---

## Anti-patterns

- Do not hand off AI Custom print files to MCAE without completing mesh validation — invalid files cause wasted production runs
- Do not skip QA on catalog orders — MCAE batch issues affect catalog and custom equally
- Do not generate Zásilkovna labels manually outside the API integration — manual labels bypass order status tracking
- Do not package before QA is complete — once packaged, defect identification becomes slower
- Do not accept a return without photos — required for MCAE reprint claims and Zásilkovna damage claims
