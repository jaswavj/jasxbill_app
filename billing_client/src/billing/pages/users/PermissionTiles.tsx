import React from 'react';

export type PermItem = {
  id: number;
  name: string;
  isGroup?: number;
  groupId?: number;
};

export const permIcon = (name: string) => {
  const n = (name || '').toLowerCase();
  if (n.includes('bill') && n.includes('stock')) return 'fas fa-box-open';
  if (n.includes('bill')) return 'fas fa-file-invoice';
  if (n.includes('master')) return 'fas fa-box';
  if (n.includes('stock')) return 'fas fa-boxes';
  if (n.includes('user')) return 'fas fa-user-shield';
  if (n.includes('invent')) return 'fas fa-warehouse';
  if (n.includes('account')) return 'fas fa-file-alt';
  if (n.includes('admin')) return 'fas fa-cog';
  if (n.includes('stat')) return 'fas fa-chart-pie';
  if (n.includes('credit')) return 'fas fa-money-check-alt';
  if (n.includes('order')) return 'fas fa-list-alt';
  if (n.includes('expense')) return 'fas fa-money-bill-wave';
  if (n.includes('discount')) return 'fas fa-percent';
  if (n.includes('print')) return 'fas fa-print';
  if (n.includes('cancel')) return 'fas fa-ban';
  if (n.includes('edit') || n.includes('date')) return 'fas fa-pen';
  if (n.includes('exchange') || n.includes('return')) return 'fas fa-sync';
  if (n.includes('gst')) return 'fas fa-calculator';
  if (n.includes('purchase')) return 'fas fa-file-import';
  if (n.includes('dashboard')) return 'fas fa-chart-line';
  if (n.includes('customer')) return 'fas fa-users';
  return 'fas fa-shield-alt';
};

type Group = { group: PermItem; children: PermItem[] };

const toGroups = (items: PermItem[]): Group[] | null => {
  const hasTree = items.some((i) => Number(i.isGroup) === 1 || Number(i.groupId) > 0);
  if (!hasTree) return null;
  const mains = items.filter((i) => Number(i.isGroup) === 1 || (Number(i.groupId || 0) === 0 && Number(i.isGroup) !== 0));
  return mains.map((group) => ({
    group,
    children: items.filter((i) => Number(i.isGroup) === 0 && Number(i.groupId) === group.id),
  })).concat(
    items
      .filter((i) => Number(i.isGroup) === 0 && Number(i.groupId) > 0 && !mains.some((g) => g.id === Number(i.groupId)))
      .map((child) => ({ group: child, children: [] as PermItem[] }))
  );
};

type Props = {
  items: PermItem[];
  selected: number[];
  onToggle: (id: number) => void;
  onSet?: (ids: number[]) => void;
  emptyText?: string;
};

const Tile: React.FC<{
  item: PermItem;
  on: boolean;
  onToggle: (id: number) => void;
}> = ({ item, on, onToggle }) => (
  <button
    type="button"
    className={`usr-tile${on ? ' on' : ''}`}
    onClick={() => onToggle(item.id)}
    aria-pressed={on}
  >
    <span className="usr-tile-ico"><i className={permIcon(item.name)} /></span>
    <span className="usr-tile-name">{item.name}</span>
    <i className={`usr-tile-mark fas ${on ? 'fa-check-circle' : 'fa-circle'}`} />
  </button>
);

const PermissionTiles: React.FC<Props> = ({ items, selected, onToggle, onSet, emptyText }) => {
  if (items.length === 0) {
    return <div className="mst-note">{emptyText || 'No items found.'}</div>;
  }
  const groups = toGroups(items);
  if (!groups) {
    return (
      <div className="usr-tiles">
        {items.map((item) => (
          <Tile key={item.id} item={item} on={selected.includes(item.id)} onToggle={onToggle} />
        ))}
      </div>
    );
  }

  const toggleGroup = (group: Group) => {
    const ids = [group.group.id, ...group.children.map((c) => c.id)];
    const allOn = ids.every((id) => selected.includes(id));
    if (onSet) {
      onSet(allOn ? selected.filter((id) => !ids.includes(id)) : Array.from(new Set([...selected, ...ids])));
      return;
    }
    ids.forEach((id) => {
      if (allOn === selected.includes(id)) onToggle(id);
    });
  };

  const toggleChild = (group: Group, childId: number) => {
    if (!onSet) {
      onToggle(childId);
      return;
    }
    const next = selected.includes(childId)
      ? selected.filter((id) => id !== childId)
      : [...selected, childId];
    const childIds = group.children.map((c) => c.id);
    const anyChild = childIds.some((id) => (id === childId ? !selected.includes(id) : next.includes(id)));
    const withoutParent = next.filter((id) => id !== group.group.id);
    onSet(anyChild ? Array.from(new Set([...withoutParent, group.group.id])) : withoutParent);
  };

  return (
    <div className="usr-perm-list">
      {groups.map((g) => {
        const childIds = g.children.map((c) => c.id);
        const onCount = childIds.filter((id) => selected.includes(id)).length;
        const groupOn = g.children.length === 0
          ? selected.includes(g.group.id)
          : onCount === childIds.length && childIds.length > 0;
        const some = onCount > 0 && !groupOn;
        if (g.children.length === 0) {
          return (
            <div key={g.group.id} className="usr-perm-group usr-perm-leaf">
              <Tile item={g.group} on={selected.includes(g.group.id)} onToggle={onToggle} />
            </div>
          );
        }
        return (
          <div key={g.group.id} className={`usr-perm-group${groupOn ? ' on' : some ? ' some' : ''}`}>
            <button type="button" className="usr-perm-head" onClick={() => toggleGroup(g)} aria-pressed={groupOn}>
              <span className="usr-tile-ico"><i className={permIcon(g.group.name)} /></span>
              <span className="usr-perm-head-txt">
                <strong>{g.group.name}</strong>
                <em>{onCount} of {childIds.length} screens</em>
              </span>
              <i className={`usr-tile-mark fas ${groupOn ? 'fa-check-circle' : some ? 'fa-minus-circle' : 'fa-circle'}`} />
            </button>
            <div className="usr-tiles">
              {g.children.map((item) => (
                <Tile
                  key={item.id}
                  item={item}
                  on={selected.includes(item.id)}
                  onToggle={() => toggleChild(g, item.id)}
                />
              ))}
            </div>
          </div>
        );
      })}
    </div>
  );
};

export const PermissionBar: React.FC<{
  selected: number;
  total: number;
  onSelectAll: () => void;
  onClear: () => void;
  disabled?: boolean;
}> = ({ selected, total, onSelectAll, onClear, disabled }) => (
  <div className="usr-tile-bar">
    <span className="usr-count">{selected} of {total} selected</span>
    <div className="usr-tile-acts">
      <button className="mst-btn mst-btn-outline" type="button" disabled={disabled || total === 0} onClick={onSelectAll}>Select all</button>
      <button className="mst-btn mst-btn-outline" type="button" disabled={disabled || selected === 0} onClick={onClear}>Clear</button>
    </div>
  </div>
);

export default PermissionTiles;
