import React from 'react';
import { useSelector } from 'react-redux';
import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { RootState } from '../../state/store';
import { moduleIdForPath } from '../config/menu.config';
import { routerPathNames } from '../../routes/routerPathNames';

const ModuleAccessGuard: React.FC = () => {
  const location = useLocation();
  const moduleIds = useSelector((s: RootState) => s.loginData.moduleIds || []);
  const needed = moduleIdForPath(location.pathname);
  if (needed != null && !moduleIds.map(Number).includes(needed)) {
    return <Navigate to={routerPathNames.dashboard} replace />;
  }
  return <Outlet />;
};

export default ModuleAccessGuard;
