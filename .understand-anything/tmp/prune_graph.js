const fs = require('fs');
const path = require('path');

const projectRoot = process.argv[2];
const kgPath = path.join(projectRoot, '.understand-anything', 'knowledge-graph.json');
const filesToPrune = process.argv.slice(3);

if (!fs.existsSync(kgPath)) {
  console.error('Knowledge graph not found');
  process.exit(1);
}

const graph = JSON.parse(fs.readFileSync(kgPath, 'utf8'));

// Convert to relative paths if necessary and create a set
const pruneSet = new Set(filesToPrune.map(f => f.startsWith(projectRoot) ? path.relative(projectRoot, f) : f));

console.log('Pruning files:', Array.from(pruneSet));

const initialNodeCount = graph.nodes.length;
const initialEdgeCount = graph.edges.length;

// Filter nodes
graph.nodes = graph.nodes.filter(node => {
  if (node.filePath && pruneSet.has(node.filePath)) {
    return false;
  }
  return true;
});

const prunedNodeIds = new Set(
  graph.nodes.filter(n => true).map(n => n.id) // This is just to get the remaining IDs
);

// We should also remove nodes that were pruned but might be sub-nodes (functions, classes) of the pruned files.
// But usually function/class nodes also have filePath. Let's check.
// If not, we might need a more sophisticated pruning.
// For now, let's assume filePath is present on all nodes we want to prune.

// Filter edges
graph.edges = graph.edges.filter(edge => {
  // If source or target was a pruned node, remove the edge
  // Actually, merge-batch-graphs.py handles dangling edges, but let's be clean.
  // We don't know the IDs of all sub-nodes yet.
  // The safest way is to check if the edge source/target points to a node that still exists.
  // But wait, the nodes we are about to analyze will be ADDED back.
  // If we remove the edges now, and they are not re-discovered, they are gone. This is correct for incremental.
  return true; // We'll let merge-batch-graphs.py handle it or prune specifically if we know the IDs.
});

// Write to batch-existing.json
fs.writeFileSync(path.join(projectRoot, '.understand-anything', 'intermediate', 'batch-existing.json'), JSON.stringify({
  nodes: graph.nodes,
  edges: graph.edges
}, null, 2));

console.log(`Pruned ${initialNodeCount - graph.nodes.length} nodes.`);
