const { app, BrowserWindow, dialog, ipcMain, shell } = require('electron');
const fs = require('fs');
const path = require('path');

process.on('uncaughtException', (err) => {
  try {
    dialog.showErrorBox('JASXBILL', String(err && err.stack ? err.stack : err));
  } catch {
    /* ignore */
  }
});

const DEFAULT_API = 'http://localhost:9098';
const isPackaged = app.isPackaged;

const readJson = (file) => {
  try {
    if (fs.existsSync(file)) {
      return JSON.parse(fs.readFileSync(file, 'utf8'));
    }
  } catch {
    /* use fallback */
  }
  return null;
};

const configPath = () => {
  if (isPackaged) {
    return path.join(path.dirname(process.execPath), 'desktop-config.json');
  }
  return path.join(__dirname, 'desktop-config.json');
};

const bundledConfigPath = () =>
  isPackaged
    ? path.join(process.resourcesPath, 'desktop-config.json')
    : path.join(__dirname, 'desktop-config.json');

const ensureUserConfig = () => {
  const dest = configPath();
  if (fs.existsSync(dest)) return dest;
  const src = bundledConfigPath();
  if (src !== dest && fs.existsSync(src)) {
    try {
      fs.copyFileSync(src, dest);
    } catch {
      return src;
    }
  }
  return dest;
};

const readConfig = () => {
  const file = ensureUserConfig();
  const data = readJson(file) || readJson(bundledConfigPath()) || {};
  const apiBaseUrl = String(data.apiBaseUrl || DEFAULT_API).trim().replace(/\/$/, '') || DEFAULT_API;
  return { apiBaseUrl };
};

ipcMain.on('jasx-get-config', (event) => {
  event.returnValue = readConfig();
});

const createWindow = () => {
  const icon = path.join(__dirname, '..', 'public', 'jasxbill.png');
  const win = new BrowserWindow({
    width: 1400,
    height: 900,
    minWidth: 1024,
    minHeight: 640,
    title: 'JASXBILL',
    icon: fs.existsSync(icon) ? icon : undefined,
    show: true,
    autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.cjs'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false,
    },
  });

  win.once('ready-to-show', () => {
    win.show();
    win.maximize();
  });
  win.webContents.on('did-fail-load', (_event, code, desc, url) => {
    dialog.showErrorBox('JASXBILL', `Failed to load screen (${code}): ${desc}\n${url}`);
  });

  win.webContents.setWindowOpenHandler(({ url }) => {
    if (/^https?:\/\//i.test(url) && !url.startsWith('http://localhost') && !url.startsWith('http://127.0.0.1')) {
      shell.openExternal(url);
      return { action: 'deny' };
    }
    return {
      action: 'allow',
      overrideBrowserWindowOptions: {
        autoHideMenuBar: true,
      },
    };
  });

  if (!isPackaged) {
    win.loadURL('http://localhost:5174/billing/');
  } else {
    win.loadFile(path.join(app.getAppPath(), 'build', 'index.html'));
  }
};

app.whenReady().then(() => {
  createWindow();
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
