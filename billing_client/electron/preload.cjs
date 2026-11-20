const { contextBridge, ipcRenderer } = require('electron');

const config = ipcRenderer.sendSync('jasx-get-config') || {};

contextBridge.exposeInMainWorld('jasxDesktop', {
  apiBaseUrl: typeof config.apiBaseUrl === 'string' ? config.apiBaseUrl : '',
});
