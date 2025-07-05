const express = require('express');
const fs = require('fs');
const { exec } = require('child_process');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const BASE = '/app/projects';

app.post('/project/create', (req, res) => {
  const name = req.body.project_name;
  const path = `${BASE}/${name}`;
  if (fs.existsSync(path)) return res.status(400).send('Exists');
  exec(`flutter create ${name}`, { cwd: BASE }, (e, o, err) => {
    if (e) return res.status(500).send(err);
    res.send({ ok: true });
  });
});

app.get('/project/:name/files', (req, res) => {
  const p = `${BASE}/${req.params.name}/lib`;
  const out = {};
  fs.readdirSync(p).forEach(f => {
    out[f] = fs.readFileSync(`${p}/${f}`, 'utf8');
  });
  res.json(out);
});

app.post('/project/:name/files', (req, res) => {
  const p = `${BASE}/${req.params.name}/lib/${req.body.filename}`;
  fs.writeFileSync(p, req.body.content);
  res.send({ ok: true });
});

app.listen(8080, () => console.log('Listening on 8080'));
