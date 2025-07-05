const express = require('express');
const fs = require('fs');
const { exec } = require('child_process');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const BASE_PATH = '/app/projects';

app.post('/project/create', (req, res) => {
  const name = req.body.project_name;
  const projectPath = `${BASE_PATH}/${name}`;
  if (fs.existsSync(projectPath)) return res.status(400).send('Project already exists.');

  exec(`flutter create ${name}`, { cwd: BASE_PATH }, (err, stdout, stderr) => {
    if (err) return res.status(500).send(stderr);
    res.send({ message: 'Project created successfully' });
  });
});

app.get('/project/:name/files', (req, res) => {
  const projectPath = `${BASE_PATH}/${req.params.name}/lib`;
  const files = {};
  fs.readdir(projectPath, (err, fileList) => {
    if (err) return res.status(500).send(err);
    fileList.forEach((file) => {
      const content = fs.readFileSync(`${projectPath}/${file}`, 'utf8');
      files[file] = content;
    });
    res.json(files);
  });
});

app.post('/project/:name/files', (req, res) => {
  const projectPath = `${BASE_PATH}/${req.params.name}/lib/${req.body.filename}`;
  fs.writeFile(projectPath, req.body.content, (err) => {
    if (err) return res.status(500).send(err);
    res.send({ message: 'File saved successfully' });
  });
});

app.listen(8080, () => {
  console.log('Server running on port 8080');
});
