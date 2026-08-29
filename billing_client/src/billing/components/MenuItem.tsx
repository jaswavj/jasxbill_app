import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faChevronRight } from '@fortawesome/free-solid-svg-icons';
import { MenuItemConfig } from '../config/menu.config';
import { useSidebar } from '../../context/SidebarContext';
import { isExpandedMenu } from '../../components/sidebarExpanded';

interface MenuItemProps {
  item: MenuItemConfig;
  level?: number;
  collapsed?: boolean;
  onNavigate?: () => void;
  expandedMenuId?: string | string[] | null;
  setExpandedMenuId?: (id: string | null) => void;
}

const MenuItem: React.FC<MenuItemProps> = ({
  item,
  level = 0,
  collapsed = false,
  onNavigate,
  expandedMenuId,
  setExpandedMenuId,
}) => {
  const [localExpanded, setLocalExpanded] = useState(false);
  const location = useLocation();
  const { toggleSidebar } = useSidebar();
  const hasSubmenus = item.submenus && item.submenus.length > 0;
  const isActive = item.url
    ? location.pathname === item.url || location.pathname.endsWith(`/${item.url}`)
    : false;

  const expanded = level === 0 ? isExpandedMenu(expandedMenuId, item.id) : localExpanded;

  const handleClick = () => {
    if (hasSubmenus) {
      if (collapsed) {
        if (level === 0 && setExpandedMenuId) {
          if (!isExpandedMenu(expandedMenuId, item.id)) {
            setExpandedMenuId(item.id);
          }
        } else {
          setLocalExpanded(true);
        }
        toggleSidebar();
        return;
      }

      if (level === 0 && setExpandedMenuId) {
        setExpandedMenuId(item.id);
      } else {
        setLocalExpanded(!localExpanded);
      }
    } else if (item.url && onNavigate) {
      onNavigate();
    }
  };

  const content = (
    <>
      <span className="menu-item-icon">
        <i className={item.icon}></i>
      </span>
      <span className="menu-item-text">{item.name}</span>
      {hasSubmenus && (
        <span className={`menu-item-arrow ${expanded ? 'expanded' : ''}`}>
          <FontAwesomeIcon icon={faChevronRight} />
        </span>
      )}
    </>
  );

  return (
    <li className="menu-item">
      {item.url && !hasSubmenus ? (
        <Link
          to={item.url}
          className={`menu-item-button ${isActive ? 'active' : ''} ${expanded ? 'is-open' : ''}`}
          onClick={handleClick}
        >
          {content}
        </Link>
      ) : (
        <button
          className={`menu-item-button ${isActive ? 'active' : ''} ${expanded ? 'is-open' : ''}`}
          onClick={handleClick}
        >
          {content}
        </button>
      )}
      {hasSubmenus && (
        <ul className={`submenu ${expanded ? 'expanded' : ''}`}>
          <li className="submenu-panel">
            <ul className="submenu-list">
              {item.submenus!.map((submenu) => (
                <MenuItem
                  key={submenu.id}
                  item={submenu}
                  level={level + 1}
                  collapsed={collapsed}
                  onNavigate={onNavigate}
                  expandedMenuId={expandedMenuId}
                  setExpandedMenuId={setExpandedMenuId}
                />
              ))}
            </ul>
          </li>
        </ul>
      )}
    </li>
  );
};

export default MenuItem;
