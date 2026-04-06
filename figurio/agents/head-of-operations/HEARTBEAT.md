# Heartbeat

The Head of Operations runs a daily operational rhythm to keep the order pipeline flowing without gaps or surprises.

## Daily Heartbeat

### 1. Check Order Pipeline Status
- Review all open orders by stage: awaiting file prep, sent to MCAE, in production, awaiting QC, packaging, dispatched.
- Flag any orders that have been sitting in a single stage longer than the expected window.
- Identify any orders approaching promised delivery dates that are at risk.

### 2. Review Pending Shipments
- Confirm all orders that completed QC and packaging have shipping labels generated.
- Verify labels match the correct carrier: Zasilkovna for Czech Republic addresses, DHL for international.
- Check that all dispatched orders have tracking numbers recorded and customer notifications sent.
- Review any carrier alerts: failed deliveries, held packages, customs issues on international shipments.

### 3. Follow Up on MCAE Production Queue
- Check current queue status with MCAE: how many orders are in production, what is the estimated completion date for each batch?
- Follow up on any orders that are overdue against MCAE's committed turnaround SLA.
- Send any new print files that are ready and have not yet been submitted.
- Confirm receipt of completed prints if using a hub-and-spoke handoff model (MCAE prints, Figurio inspects and packs).

### 4. Handle Fulfillment Issues
- Review any quality flags raised during inspection: defective prints, wrong colors, structural issues. Initiate reprint requests with MCAE as needed.
- Review any customer-reported issues from the previous 24 hours: damaged deliveries, missing packages, wrong items. Determine appropriate resolution (replacement, refund, carrier claim).
- Check for any packaging stock running low — flag reorder if approaching minimum threshold.
- Review any carrier escalations or disputes requiring action.

## Weekly Cadence

Every Monday:
- Pull weekly KPI snapshot: orders processed, print success rate, dispatch time, transit time, damage/return rate.
- Review MCAE invoice for the previous week against order log — verify per-unit pricing matches contracted rates.
- Update production and shipping forecasts based on incoming order volume trends.
- Report operational summary to CEO: green/amber/red status across all KPI areas, any issues requiring CEO attention.

## Monthly Cadence

- Full KPI review against targets (see AGENTS.md for KPI table).
- Vendor review meeting with MCAE: discuss production performance, defect trends, capacity outlook, pricing.
- Packaging inventory audit: stock levels, upcoming design changes, reorder planning.
- Carrier cost review: actual spend vs. budget, any rate changes from Zasilkovna or DHL.
- Identify one operational improvement to implement in the coming month (process, tooling, or vendor-related).
