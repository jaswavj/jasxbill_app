const isDev: boolean = import.meta.env.DEV;

let routerBaseUrl = '/billing';

const envApi = import.meta.env.VITE_API_BASE_URL;
const apiBaseName =
  envApi && envApi !== 'auto'
    ? envApi.replace(/\/$/, '')
    : typeof window !== 'undefined'
      ? `${window.location.protocol}//${window.location.hostname}:9098`
      : 'http://localhost:9098';

const billingConfig = {
  apiBaseName,
  appName: import.meta.env.VITE_APP_NAME || 'JASXBILL',
};

export { routerBaseUrl, isDev };

export default billingConfig;
