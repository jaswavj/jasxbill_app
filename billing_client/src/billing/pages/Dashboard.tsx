import React from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../state/store';

const Dashboard: React.FC = () => {
  const loginData = useSelector((state: RootState) => state.loginData);
  const displayName = loginData.fullName || loginData.name || loginData.userName || 'User';

  return (
    <div style={{ padding: '2rem' }}>
      <h2 style={{ marginBottom: '0.5rem' }}>Welcome, {displayName}</h2>
      <p style={{ color: 'var(--color-text-muted)' }}>
        Select a menu item from the sidebar. Screens will be added step by step.
      </p>
    </div>
  );
};

export default Dashboard;
