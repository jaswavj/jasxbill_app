import React, { useEffect, useState } from 'react';
import { toast } from 'react-toastify';
import { usersApi, usersData, usersError } from '../../../api/users/users-api-service';
import '../master/Master.css';
import './Users.css';

type Kind = 'module' | 'special';
type UserOpt = { id: number; name: string };
type Item = { id: number; name: string };
type Perms = { userId: number; name: string; all: Item[]; selectedIds: number[] };

const PermissionPage: React.FC<{ kind: Kind }> = ({ kind }) => {
  const isModule = kind === 'module';
  const [users, setUsers] = useState<UserOpt[]>([]);
  const [userId, setUserId] = useState('');
  const [items, setItems] = useState<Item[]>([]);
  const [selected, setSelected] = useState<number[]>([]);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    usersApi.list()
      .then((res) => setUsers(usersData<UserOpt[]>(res) || []))
      .catch((err) => toast.error(usersError(err, 'Could not load users')));
  }, []);

  const load = async (id: string) => {
    setUserId(id);
    if (!id) {
      setItems([]);
      setSelected([]);
      return;
    }
    try {
      const res = isModule ? await usersApi.permissions(Number(id)) : await usersApi.specialPermissions(Number(id));
      const data = usersData<Perms>(res);
      setItems(data.all || []);
      setSelected((data.selectedIds || []).map(Number));
    } catch (err) {
      toast.error(usersError(err, 'Could not load permissions'));
    }
  };

  const toggle = (id: number) => {
    setSelected((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  };

  const save = async () => {
    if (!userId) {
      toast.warning('Choose a user');
      return;
    }
    setBusy(true);
    try {
      if (isModule) {
        await usersApi.savePermissions(Number(userId), selected);
      } else {
        await usersApi.saveSpecialPermissions(Number(userId), selected);
      }
      toast.success('Permissions updated');
    } catch (err) {
      toast.error(usersError(err, 'Could not update permissions'));
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="mst-page">
      <h2 className="mst-title">
        <i className={isModule ? 'fas fa-key' : 'fas fa-unlock'} />
        {isModule ? 'Module Permission' : 'Special Permission'}
      </h2>
      <div className="mst-card usr-narrow">
        <div className="mst-card-h">{isModule ? 'User Permissions' : 'Special Permissions'}</div>
        <div className="mst-card-b mst-form one-col">
          <div className="mst-fg">
            <label>Choose a User</label>
            <select className="mst-sel" value={userId} onChange={(e) => load(e.target.value)}>
              <option value="">-- Select User --</option>
              {users.map((u) => (
                <option key={u.id} value={u.id}>{u.name}</option>
              ))}
            </select>
          </div>
          {userId && (
            <>
              <div className="mst-fg">
                <label>{isModule ? 'Select modules' : 'Select special permissions'}</label>
                <div className="usr-checks">
                  {items.length === 0 ? (
                    <div className="mst-note">No items found.</div>
                  ) : (
                    items.map((item) => (
                      <label key={item.id} className="mst-check">
                        <input type="checkbox" checked={selected.includes(item.id)} onChange={() => toggle(item.id)} />
                        {item.name}
                      </label>
                    ))
                  )}
                </div>
              </div>
              <div className="mst-actions">
                <button className="mst-btn mst-btn-primary" type="button" disabled={busy} onClick={save} style={{ width: '100%' }}>
                  {busy ? 'Saving…' : 'Update Permissions'}
                </button>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export const ModulePermissionPage: React.FC = () => <PermissionPage kind="module" />;
export const SpecialPermissionPage: React.FC = () => <PermissionPage kind="special" />;

export default ModulePermissionPage;
