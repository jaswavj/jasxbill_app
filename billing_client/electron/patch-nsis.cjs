const fs = require('fs');
const path = require('path');

const src = path.join(__dirname, 'nsis', 'multiUser.nsh');
const dest = path.join(
  __dirname,
  '..',
  'node_modules',
  'app-builder-lib',
  'templates',
  'nsis',
  'multiUser.nsh'
);

if (!fs.existsSync(src)) {
  console.error('Missing NSIS patch file:', src);
  process.exit(1);
}
if (!fs.existsSync(dest)) {
  console.error('electron-builder NSIS template not found:', dest);
  process.exit(1);
}
fs.copyFileSync(src, dest);
console.log('Patched NSIS multiUser.nsh (Windows 11 installer crash fix)');
