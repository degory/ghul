#!/bin/bash
# Script to verify if the ghūl compiler can bootstrap itself
#
# This script runs the bootstrap process and reports the result.
# The bootstrap process compiles the compiler with itself through 4 passes,
# then verifies that passes 3 and 4 produce identical IL output (except for version info).

set -e

echo "🔧 Verifying ghūl compiler bootstrap capability..."
echo

# Store the original compiler version for comparison
ORIGINAL_VERSION=$(dotnet ghul-compiler 2>/dev/null || echo "No compiler installed")
echo "📍 Starting with compiler: ${ORIGINAL_VERSION}"
echo

# Run the bootstrap script
echo "🚀 Running bootstrap test..."
START_TIME=$(date +%s)

if ./build/bootstrap.sh > /tmp/bootstrap-output.log 2>&1; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    # Extract the final success message
    FINAL_VERSION=$(tail -1 /tmp/bootstrap-output.log | grep -o 'ghūl [0-9.][^[:space:]]*' || echo "unknown version")
    
    echo "✅ BOOTSTRAP SUCCESSFUL!"
    echo "   Duration: ${DURATION} seconds"
    echo "   Final compiler: ${FINAL_VERSION}"
    echo "   The compiler successfully compiled itself and passed IL verification."
    echo
    echo "📊 Bootstrap Process Summary:"
    echo "   - Pass 1: Compile with existing compiler"
    echo "   - Pass 2: Compile with pass 1 result"  
    echo "   - Pass 3: Compile with pass 2 result"
    echo "   - Pass 4: Compile with pass 3 result"
    echo "   - Verification: Pass 3 and Pass 4 IL output match"
    echo
    exit 0
else
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo "❌ BOOTSTRAP FAILED!"
    echo "   Duration: ${DURATION} seconds"
    echo "   Check /tmp/bootstrap-output.log for details"
    echo
    tail -20 /tmp/bootstrap-output.log
    exit 1
fi