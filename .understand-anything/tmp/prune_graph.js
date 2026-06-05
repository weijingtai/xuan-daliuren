const fs = require('fs');
const path = require('path');

const projectRoot = process.argv[2];
const changedFilesPath = path.join(projectRoot, '.understand-anything/tmp/changed-files.txt');
const graphPath = path.join(projectRoot, '.understand-anything/knowledge-graph.json');
const outputPath = path.join(projectRoot, '.understand-anything/intermediate/batch-existing.json');

const changedFiles = new Set(fs.readFileSync(changedFilesPath, 'utf8').split('\n').map(l => l.trim()).filter(Boolean));
const graph = JSON.parse(fs.readFileSync(graphPath, 'utf8'));

const removedNodeIds = new Set();
const prunedNodes = graph.nodes.filter(node => {
  if (changedFiles.has(node.filePath)) {
    removedNodeIds.add(node.id);
    return false;
  }
  return true;
});

const prunedEdges = graph.edges.filter(edge => {
  return !removedNodeIds.has(edge.source) && !removedNodeIds.has(edge.target);
});

fs.writeFileSync(outputPath, JSON.stringify({ nodes: prunedNodes, edges: prunedEdges }, null, 2));
console.log(`Pruned ${graph.nodes.length - prunedNodes.length} nodes and ${graph.edges.length - prunedEdges.length} edges.`);
