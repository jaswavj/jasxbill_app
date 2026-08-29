const isDev: boolean = import.meta.env.DEV;

let routerBaseUrl = '/billing';

const billingConfig = {
  apiBaseName: import.meta.env.VITE_API_BASE_URL || 'http://localhost:9092',
  appName: import.meta.env.VITE_APP_NAME || 'JASXBILL',
};

export { routerBaseUrl, isDev };

export default billingConfig;
