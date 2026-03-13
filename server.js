const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Serve word list
const words = require('./words.json');
app.get('/api/words', (req, res) => {
  res.json(words);
});

// Save experiment results — each run gets its own CSV file
// Organized as: data/{participantId}/{condition}_{timestamp}.csv
app.post('/api/results', (req, res) => {
  const rows = req.body; // array of trial objects

  if (!Array.isArray(rows) || rows.length === 0) {
    return res.status(400).json({ error: 'Expected a non-empty array of trial results.' });
  }

  const pid = rows[0].participantId || 'unknown';
  const cond = rows[0].condition || 'unknown';
  const ts = new Date().toISOString().replace(/[:.]/g, '-'); // safe for filenames

  // Create participant folder: data/{participantId}/
  const participantDir = path.join(__dirname, 'data', pid);
  if (!fs.existsSync(participantDir)) {
    fs.mkdirSync(participantDir, { recursive: true });
  }

  // File: data/{participantId}/{condition}_{timestamp}.csv
  const csvPath = path.join(participantDir, `${cond}_${ts}.csv`);

  // CSV header
  const header = 'participantId,condition,phase,trialIndex,targetWord,typedWord,accuracy,responseTimeMs,timestamp';

  // Build CSV lines
  const lines = rows.map(r => {
    const typed = `"${(r.typedWord || '').replace(/"/g, '""')}"`;
    return [
      r.participantId,
      r.condition,
      r.phase,
      r.trialIndex,
      r.targetWord,
      typed,
      r.accuracy,
      r.responseTimeMs,
      r.timestamp
    ].join(',');
  }).join('\n');

  fs.writeFileSync(csvPath, header + '\n' + lines + '\n', 'utf8');

  console.log(`✓ Saved ${rows.length} trial(s) → ${path.relative(__dirname, csvPath)}`);
  res.json({ ok: true, saved: rows.length, file: `${pid}/${cond}_${ts}.csv` });
});

app.listen(PORT, () => {
  console.log(`\n  🧪  MIE286 Experiment Server`);
  console.log(`  ➜  http://localhost:${PORT}\n`);
});
