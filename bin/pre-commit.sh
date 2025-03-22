#!/bin/bash
echo "🚀 Running pre-commit hook..."
cd "$(dirname "$0")/.." || exit 1

echo "🧭 Running from: $(pwd)"

TEST_TYPE=$1

# Function to time any block of commands
run_with_timer() {
  local label=$1
  shift
  local start=$(date +%s)
  "$@"
  local status=$?
  local end=$(date +%s)
  local runtime=$((end - start))
  echo "⏱️  $label finished in $runtime seconds with status $status"
  return $status
}

if [[ "$TEST_TYPE" == "unit" ]]; then
  echo "🔬 Running unit tests (via Surefire includes)..."
  run_with_timer "Unit tests" mvn test -q
  [[ $? -ne 0 ]] && echo "❌ Unit tests failed! Aborting commit." && exit 1

elif [[ "$TEST_TYPE" == "acceptance" ]]; then
  echo "🧪 Running acceptance tests (excluding @slow)..."
  run_with_timer "Acceptance tests" mvn test -q -Dtest=co.rapidtransit.acceptance.RunCucumberTest
  [[ $? -ne 0 ]] && echo "❌ Acceptance tests failed! Aborting commit." && exit 1

elif [[ "$TEST_TYPE" == "all" ]]; then
  echo "📦 Running all tests (unit + acceptance)..."

  # Run unit tests (honours Surefire config in pom.xml)
  run_with_timer "Unit tests" mvn test -q
  UNIT_STATUS=$?

  # Run acceptance tests explicitly
  run_with_timer "Acceptance tests" mvn test -q -Dtest=co.rapidtransit.acceptance.RunCucumberTest
  ACCEPTANCE_STATUS=$?

  # Evaluate both
  if [[ $UNIT_STATUS -ne 0 || $ACCEPTANCE_STATUS -ne 0 ]]; then
    echo "❌ One or more test types failed! Aborting commit."
    exit 1
  fi

else
  echo "⚠️  Usage: ./bin/pre-commit.sh [unit|acceptance|all]"
  exit 1
fi

echo "✅ All selected tests passed! Proceeding with commit."
exit 0
