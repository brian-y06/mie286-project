/* =============================================
   MIE286 Experiment — Client-side Logic (app.js)
   ============================================= */

(function () {
  'use strict';

  // ── URL params ──
  const params = new URLSearchParams(window.location.search);
  const participantId = params.get('pid') || 'UNKNOWN';
  const condition = params.get('condition') || 'visual'; // "visual" | "auditory"

  // ── DOM refs ──
  const screenIntro = document.getElementById('screenIntro');
  const screenTrial = document.getElementById('screenTrial');
  const screenPause = document.getElementById('screenPause');
  const screenDone  = document.getElementById('screenDone');
  const hudPhase    = document.getElementById('hudPhase');
  const hudProgress = document.getElementById('hudProgress');
  const cueText     = document.getElementById('cueText');
  const trialInput  = document.getElementById('trialInput');
  const btnBegin    = document.getElementById('btnBegin');
  const doneStats   = document.getElementById('doneStats');

  // ── Config ──
  const CONTROL_COUNT = 5;       // first N words are control (always visual)
  const INTER_TRIAL_MS = 1500;   // pause between trials
  const CUE_DELAY_MS   = 500;    // delay before cue after screen switch

  // ── State ──
  let words = [];
  let trialIndex = 0;
  let cueTimestamp = 0;
  const results = [];

  // ── Helpers ──
  function showScreen(screen) {
    [screenIntro, screenTrial, screenPause, screenDone].forEach(s => s.classList.remove('active'));
    screen.classList.add('active');
  }

  function isControlPhase() {
    return trialIndex < CONTROL_COUNT;
  }

  function currentPhaseLabel() {
    return isControlPhase() ? 'control' : 'experimental';
  }

  // ── Speech Synthesis helper ──
  function speakWord(word) {
    return new Promise((resolve) => {
      const utterance = new SpeechSynthesisUtterance(word);
      utterance.rate = 0.9;
      utterance.pitch = 1;
      utterance.volume = 1;
      utterance.onend = resolve;
      utterance.onerror = resolve; // resolve even on error so experiment continues
      speechSynthesis.speak(utterance);
    });
  }

  // ── Present a cue ──
  async function presentCue(word) {
    // Control phase uses the same modality as the selected condition
    const useVisual = condition === 'visual';

    if (useVisual) {
      // Show word on screen
      cueText.textContent = word;
      cueText.classList.add('visible');
      cueTimestamp = performance.now();
    } else {
      // Auditory: speak the word
      cueText.textContent = '';
      cueText.classList.remove('visible');
      cueTimestamp = performance.now();
      await speakWord(word);
      // cueTimestamp is set BEFORE the utterance starts so timing
      // captures the full delay from first hearing to pressing Enter
    }
  }

  // ── Run a single trial ──
  function runTrial() {
    if (trialIndex >= words.length) {
      finishExperiment();
      return;
    }

    const word = words[trialIndex];

    // Update HUD
    hudPhase.textContent = isControlPhase() ? 'CONTROL' : condition.toUpperCase();
    const total = isControlPhase() ? CONTROL_COUNT : words.length - CONTROL_COUNT;
    const current = isControlPhase() ? trialIndex + 1 : trialIndex - CONTROL_COUNT + 1;
    hudProgress.textContent = `${current} / ${total}`;

    // Show trial screen
    showScreen(screenTrial);
    trialInput.value = '';
    trialInput.focus();

    // Delay then present cue
    setTimeout(() => {
      presentCue(word);
    }, CUE_DELAY_MS);
  }

  // ── Handle response ──
  function handleResponse() {
    const responseTimestamp = performance.now();
    const responseTimeMs = Math.round(responseTimestamp - cueTimestamp);
    const typed = trialInput.value.trim().toLowerCase();
    const target = words[trialIndex].toLowerCase();
    const accuracy = typed === target ? 1 : 0;

    results.push({
      participantId,
      condition,
      phase: currentPhaseLabel(),
      trialIndex: trialIndex + 1,
      targetWord: target,
      typedWord: typed,
      accuracy,
      responseTimeMs,
      timestamp: new Date().toISOString()
    });

    // Hide cue
    cueText.classList.remove('visible');

    trialIndex++;

    // Pause then next trial
    showScreen(screenPause);
    setTimeout(runTrial, INTER_TRIAL_MS);
  }

  // ── Finish & upload ──
  async function finishExperiment() {
    showScreen(screenDone);

    // Stats
    const avgTime = Math.round(results.reduce((s, r) => s + r.responseTimeMs, 0) / results.length);
    const correctCount = results.filter(r => r.accuracy === 1).length;
    doneStats.textContent = `${results.length} trials · avg ${avgTime} ms · ${correctCount}/${results.length} correct`;

    // POST to server
    try {
      const res = await fetch('/api/results', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(results)
      });
      const data = await res.json();
      console.log('Results saved:', data);
    } catch (err) {
      console.error('Failed to save results:', err);
      alert('⚠ Could not save results to server. Please screenshot this page and tell the experimenter.');
    }
  }

  // ── Init ──
  async function init() {
    // Fetch word list
    const res = await fetch('/api/words');
    words = await res.json();

    // Bind start button
    btnBegin.addEventListener('click', () => {
      runTrial();
    });

    // Bind Enter key on input
    trialInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        if (trialInput.value.trim().length > 0) {
          handleResponse();
        }
      }
    });
  }

  init();
})();
