#!/usr/bin/env bash
set -euo pipefail

# Figurio -- Paperclip Company Import Script
# Usage: PAPERCLIP_API_URL=http://localhost:3100 ./import.sh

API="${PAPERCLIP_API_URL:-http://localhost:3100}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Figurio Company Import ==="
echo "API: $API"
echo ""

# --- 1. Create Company ---
echo "[1/7] Creating company..."
COMPANY_ID=$(curl -sf -X POST "$API/api/companies" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Figurio",
    "slug": "figurio",
    "description": "Direct-to-consumer e-commerce company that designs, produces, and delivers high-quality full-color 3D-printed figurines."
  }' | jq -r '.id')
echo "  Company ID: $COMPANY_ID"

# --- 2. Set Budget ---
echo "[2/7] Setting budget..."
curl -sf -X PATCH "$API/api/companies/$COMPANY_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "budget": {
      "totalMonthlyCents": 135000
    }
  }' > /dev/null
echo "  Budget set: $1,350/mo"

# --- 3. Create Goals ---
echo "[3/7] Creating goals..."
GOALS=(
  "Launch the Figurio web storefront with catalog browsing, cart, Stripe checkout, and order tracking"
  "Build and validate the AI-prompted custom figurine pipeline (text-to-3D, mesh repair, preview, approval)"
  "Establish production and fulfillment operations with MCAE, Zasilkovna, and DHL"
  "Create brand identity and execute a launch campaign targeting Czech and EU markets"
  "Achieve first 100 paid orders within 90 days of launch"
)
GOAL_IDS=()
for goal in "${GOALS[@]}"; do
  GID=$(curl -sf -X POST "$API/api/companies/$COMPANY_ID/goals" \
    -H "Content-Type: application/json" \
    -d "{\"description\": \"$goal\"}" | jq -r '.id')
  GOAL_IDS+=("$GID")
  echo "  Goal: $goal (ID: $GID)"
done

# --- 4. Create Agents (hierarchy order: CEO first, then managers, then ICs) ---
echo "[4/7] Creating agents..."

create_agent() {
  local slug="$1" name="$2" title="$3" parent_id="$4" budget="$5"
  local parent_arg=""
  if [ -n "$parent_id" ]; then
    parent_arg=", \"parentAgentId\": \"$parent_id\""
  fi
  local AGENT_ID
  AGENT_ID=$(curl -sf -X POST "$API/api/companies/$COMPANY_ID/agents" \
    -H "Content-Type: application/json" \
    -d "{
      \"slug\": \"$slug\",
      \"name\": \"$name\",
      \"title\": \"$title\",
      \"budgetCents\": $budget
      $parent_arg
    }" | jq -r '.id')
  echo "  $title ($slug) -> ID: $AGENT_ID"
  echo "$AGENT_ID"
}

CEO_ID=$(create_agent "ceo" "CEO" "Chief Executive Officer" "" 10000)
CTO_ID=$(create_agent "cto" "CTO" "Chief Technology Officer" "$CEO_ID" 15000)
CMO_ID=$(create_agent "cmo" "CMO" "Chief Marketing Officer" "$CEO_ID" 10000)
HEADOPS_ID=$(create_agent "head-of-operations" "Head of Operations" "Head of Operations" "$CEO_ID" 10000)
BE_ID=$(create_agent "backend-engineer" "Backend Engineer" "Backend Engineer" "$CTO_ID" 20000)
FE_ID=$(create_agent "frontend-engineer" "Frontend Engineer" "Frontend Engineer" "$CTO_ID" 20000)
ML_ID=$(create_agent "ml-engineer" "ML Engineer" "ML/AI Engineer" "$CTO_ID" 20000)
DEVOPS_ID=$(create_agent "devops-engineer" "DevOps Engineer" "DevOps Engineer" "$CTO_ID" 15000)
CC_ID=$(create_agent "content-creator" "Content Creator" "Content Creator" "$CMO_ID" 15000)

# --- 5. Upload Instruction Bundles ---
echo "[5/7] Uploading instruction bundles..."
AGENTS=("ceo" "cto" "backend-engineer" "frontend-engineer" "ml-engineer" "devops-engineer" "cmo" "content-creator" "head-of-operations")

for agent_slug in "${AGENTS[@]}"; do
  AGENT_DIR="$SCRIPT_DIR/agents/$agent_slug"
  if [ -d "$AGENT_DIR" ]; then
    for file in AGENTS.md HEARTBEAT.md SOUL.md TOOLS.md; do
      if [ -f "$AGENT_DIR/$file" ]; then
        curl -sf -X PUT "$API/api/companies/$COMPANY_ID/agents/by-slug/$agent_slug/files/$file" \
          -H "Content-Type: text/markdown" \
          --data-binary "@$AGENT_DIR/$file" > /dev/null
        echo "  $agent_slug/$file uploaded"
      fi
    done
    # Upload runtime config
    for rfile in runtime/settings.json runtime/mcp.json; do
      if [ -f "$AGENT_DIR/$rfile" ]; then
        curl -sf -X PUT "$API/api/companies/$COMPANY_ID/agents/by-slug/$agent_slug/files/$rfile" \
          -H "Content-Type: application/json" \
          --data-binary "@$AGENT_DIR/$rfile" > /dev/null
        echo "  $agent_slug/$rfile uploaded"
      fi
    done
  fi
done

# --- 6. Create Initial Tasks (assigned to CEO) ---
echo "[6/7] Creating initial tasks..."

create_task() {
  local name="$1" slug="$2" assignee_id="$3" priority="$4" goal_id="$5"
  local goal_arg=""
  if [ -n "$goal_id" ]; then
    goal_arg=", \"goalId\": \"$goal_id\""
  fi
  local TASK_ID
  TASK_ID=$(curl -sf -X POST "$API/api/companies/$COMPANY_ID/issues" \
    -H "Content-Type: application/json" \
    -d "{
      \"name\": \"$name\",
      \"slug\": \"$slug\",
      \"assigneeAgentId\": \"$assignee_id\",
      \"priority\": \"$priority\",
      \"status\": \"todo\"
      $goal_arg
    }" | jq -r '.id')
  echo "  Task: $name (ID: $TASK_ID)"
}

create_task "Define company strategy" "define-company-strategy" "$CEO_ID" "critical" "${GOAL_IDS[0]}"
create_task "Set up infrastructure" "setup-infrastructure" "$CTO_ID" "critical" "${GOAL_IDS[0]}"
create_task "Design database schema" "design-database-schema" "$CTO_ID" "critical" "${GOAL_IDS[0]}"
create_task "Build product catalog API" "build-product-catalog-api" "$CTO_ID" "critical" "${GOAL_IDS[0]}"
create_task "Build storefront frontend" "build-storefront-frontend" "$CTO_ID" "critical" "${GOAL_IDS[0]}"
create_task "Integrate Stripe payments" "integrate-stripe-payments" "$CTO_ID" "critical" "${GOAL_IDS[0]}"
create_task "Set up order tracking" "setup-order-tracking" "$CTO_ID" "high" "${GOAL_IDS[0]}"
create_task "Set up CI/CD pipelines" "setup-ci-cd" "$CTO_ID" "high" "${GOAL_IDS[0]}"
create_task "Evaluate text-to-3D services" "evaluate-text-to-3d-services" "$CTO_ID" "critical" "${GOAL_IDS[1]}"
create_task "Build mesh repair pipeline" "build-mesh-repair-pipeline" "$CTO_ID" "high" "${GOAL_IDS[1]}"
create_task "Build preview renderer" "build-preview-renderer" "$CTO_ID" "high" "${GOAL_IDS[1]}"
create_task "Negotiate MCAE pricing" "negotiate-mcae-pricing" "$CEO_ID" "critical" "${GOAL_IDS[2]}"
create_task "Integrate shipping providers" "integrate-shipping-providers" "$CTO_ID" "high" "${GOAL_IDS[2]}"
create_task "Design fulfillment workflow" "design-fulfillment-workflow" "$CEO_ID" "high" "${GOAL_IDS[2]}"
create_task "Create brand identity" "create-brand-identity" "$CEO_ID" "high" "${GOAL_IDS[3]}"
create_task "Build social media presence" "build-social-presence" "$CEO_ID" "high" "${GOAL_IDS[3]}"
create_task "Plan launch campaign" "plan-launch-campaign" "$CEO_ID" "medium" "${GOAL_IDS[3]}"
create_task "Hire 3D technician" "hire-3d-technician" "$CEO_ID" "medium" "${GOAL_IDS[1]}"
create_task "Consult IP attorney" "consult-ip-attorney" "$CEO_ID" "high" "${GOAL_IDS[3]}"

# --- 7. Summary ---
echo ""
echo "=== Import Complete ==="
echo "Company:  Figurio ($COMPANY_ID)"
echo "Agents:   9 created"
echo "Goals:    ${#GOAL_IDS[@]} created"
echo "Tasks:    19 created"
echo ""
echo "Next steps:"
echo "  1. Copy global/settings.json and global/plugins.json to your Paperclip docker/init/claude/ directory"
echo "  2. Restart the Paperclip container"
echo "  3. Verify agents are active in the Paperclip UI"
